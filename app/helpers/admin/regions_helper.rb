module Admin::RegionsHelper
  def render_region_tree(regions)
    %Q[<ul class="nav-list">#{regions.map do 
      |region| %Q[<li class=#{region.disabled_hierachy? ? 'region-disabled' : ''}>
      #{region.disabled_self? ? '&#x00D7' : '&#x2713'}
      #{link_to(region.name, edit_admin_region_path(region))}#{render_region_tree(region.sub_regions)}</li>]
    end.join}</ul>]
  end
end
