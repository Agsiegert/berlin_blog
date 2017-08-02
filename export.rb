EXPORT_PATH = Rails.root.join('tmp/scrivito_export')
WORKSPACE_TITLE = "Export Workspace (Do not Edit)"

def retry_once
  begin
    yield
  rescue
    yield
  end
end

# Export an array of CMS objects to the file 'tmp/scrivito_export/objs.json'.
def export(objs)
  json_objs = objs.map do |obj|
    object_to_json(obj)
  end

  File.write(File.join(EXPORT_PATH, 'objs.json'), JSON.pretty_generate(json_objs))
end

# Convert a given CMS object or widget to a nested hash.
def object_to_json(obj)
  json_hash = extract_custom_attrs(obj)

  # Add the internal attributes to the hash.
  json_hash[:id] = obj.id

  %w(_path _obj_class _permalink).each do |attr|
    json_hash[attr] = obj[attr] if obj[attr]
  end

  if value = obj[:_last_changed]
    json_hash['_last_changed'] = {date: value.iso8601}
  end

  json_hash
end

def extract_custom_attrs(obj)
  # Iterate over the attributes of a given CMS object or widget and convert each one
  # to a hash.
  obj.class.attribute_definitions.inject({}) do |json_hash, attr_definition|
    attr_name = attr_definition.name
    value = obj[attr_name]

    if value.present?
      json_hash[attr_name] = attr_to_json(value, attr_definition)
    end

    json_hash
  end
end

def attr_to_json(value, definition)
  case definition.type
  when "widgetlist"
    # For a widget list, each widget is recursively extraced using 'object_to_json'.
    {widgets: value.map { |widget| object_to_json(widget) }}
  when "binary"
    # Binaries are downloaded and saved locally.
    {file: download_binary(value)}
  when "reference"
    {reference: value.id}
  when "referencelist"
    {references: value.map(&:id)}
  when "link"
    {link: link_to_json(value)}
  when "linklist"
    {links: value.map { |link| link_to_json(link) }}
  when "date"
    {date: value.iso8601}
  else
    value
  end
end

def link_to_json(link)
  target_attr = if link.internal?
    {id: link.obj.id}
  else
    {url: link.url}
  end

  target_attr.merge(
    title: link.title,
    query: link.query,
    fragment: link.fragment,
    target: link.target
  )
end

def download_binary(binary)
  file_name = "#{File.dirname(binary.id).parameterize}-#{File.basename(binary.id)}"
  file_path = File.join(EXPORT_PATH, "files", file_name)
  uri = URI(binary.url)
  retry_once do
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      request = Net::HTTP::Get.new(uri)

      http.request(request) do |response|
        open(file_path, 'wb') do |io|
          response.read_body do |chunk|
            io.write chunk
          end
        end
      end
    end
  end

  file_path
end

FileUtils.rm_rf(EXPORT_PATH)
FileUtils.mkdir_p(File.join(EXPORT_PATH, "/files"))

# A working copy is created first to freeze the current content. This way, editors may
# still publish changes without the new content affecting the export.
Scrivito::Workspace.find_by_title(WORKSPACE_TITLE).try(:destroy)
workspace = Scrivito::Workspace.create(title: WORKSPACE_TITLE)
Scrivito::Workspace.current = workspace

# Use Obj.all to fetch the CMS objects in batches.
export(Obj.all)

workspace.destroy
