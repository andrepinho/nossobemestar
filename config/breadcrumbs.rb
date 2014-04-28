crumb :root do
  link "Home", root_path
end

crumb :section do |section|
  link section.name, section_path(section)
end

crumb :post do |post|
  link post.front_title, post_path(post)
  parent :section, post.section
end

crumb :local do |region|
  link "Notícias de #{region.name}", local_sections_path
end

crumb :local_post do |post|
  link post.front_title, post_path(post)
  parent :local, post.region
end

crumb :services do
  link "Guia de qualidade", services_path
end

crumb :service do |service|
  link service.name, service_path(service)
  parent :services
end

crumb :events do
  link "Agenda", events_path
end

crumb :event do |event|
  link event.name, event_path(event)
  parent :events
end

crumb :search do |query|
  link "Busca por #{query}", search_path(query)
end
