module SearchParams extend ActiveSupport::Concern

  private
  def set_search_params
    params[:page] = params[:page] ? params[:page] : 1
    @page = params[:page]
    if params[:search]
      params[:search] = params[:search].squish
      if params[:search].length == 0
        params[:search] = nil
      end
    end
    @search_param = params[:search]
  end
end
