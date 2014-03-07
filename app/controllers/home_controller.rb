# coding: utf-8

class HomeController < ApplicationController
  def index
    hide_title!
    @sections = Section.order(:ordering).all
    @posts = Post.visible.home_page
    @events = ((current_region && current_region.events ) || Event.where("region_id IS NULL")).where("ends_at > current_timestamp").order('RANDOM()').limit(3)
    @services = ((current_region && current_region.services ) || Service.where("region_id IS NULL")).order('RANDOM()').limit(3)
  end
  def email
    redirect_to root_path, notice: 'Obrigado por seu cadastro. Por favor, confirme a sua inscrição em seu email.'
  end
  def set_highlighted
    authorize! :set_highlighted, :home
    home = params[:home_highlighted].present?
    append = params[:append].present?
    attribute = (home ? :home_ordering : :ordering)
    post_from = Post.find(params[:id_from])
    post_to = Post.find_by_id(params[:id_to])
    return redirect_to root_path, alert: 'Id de post não encontrado.' unless post_to
    return redirect_to root_path, alert: 'O novo post deve ser da mesma seção do post original.' unless (home || post_from.section == post_to.section)
    ordering = post_from.read_attribute(attribute)
    filter = {}
    filter.merge!({section_id: post_from.section_id}) unless home
    if append
      4.downto(ordering + 1) do |number|
        Post.where(filter.merge(attribute => number)).update_all({ attribute => nil })
        Post.where(filter.merge(attribute => (number - 1))).update_all({ attribute => number })
      end
    end
    Post.where(filter.merge(attribute => ordering)).update_all({ attribute => nil })
    post_to.update_attribute attribute, ordering
    redirect_to root_path, notice: 'Destaque atualizado com sucesso!'
  end
end
