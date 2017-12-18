class HomeController < ApplicationController
    def index
    end

    def hello
      @name = params[:name]
    end

    def lotto
      numbers = (1..45).to_a

      @lotto = numbers.sample(6)
    end

    def lunch
      menu = ["칼국수", "뚝불", "김치찌개", "순대국"]

      @lunch = menu.sample
    end

    def search

    end

end
