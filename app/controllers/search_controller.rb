class SearchController < ApplicationController
    def search
        @model = params["search"]["model"]
        @value = params["search"]["value"]
        @how = params["search"]["how"]
        @datas = search_for(@how, @model, @value)
    end
    
    private
end
