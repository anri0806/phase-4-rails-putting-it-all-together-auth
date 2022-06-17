class RecipesController < ApplicationController
    
    def index
        if session[:user_id]
            recipes = Recipe.all
            render json: recipes, include: :user, status: :created
        else
            render json: {errors: ["Not authorized"]}, status: :unauthorized
        end
    end

    def create
        if session[:user_id]
            user = User.find_by(id: session[:user_id])
            recipe = user.recipes.create(recipe_params)

            if recipe.valid?
                render json: recipe, include: :user, status: :created
            else
                render json: {errors: ["Not valid"]}, status: :unprocessable_entity
            end
        else
            render json: {errors: ["Not authorized"]}, status: :unauthorized
        end
    end

    private

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end
end
