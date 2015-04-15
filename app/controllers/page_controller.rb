class PageController < ApplicationController
  def index
  end

  def error_404
    head 404
  end
end
