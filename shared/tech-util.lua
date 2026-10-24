local Module = {}

function Module.createEffectsUnlocksRecipes(recipesList)
    local effects_table = {}

    for _, recipeName in ipairs(recipesList) do
        local unlockRecipe = {
            type = "unlock-recipe",
            recipe = recipeName
        }

        table.insert(effects_table, unlockRecipe)
    end

    return effects_table

    -- {
    --     {
    --         type = "unlock-recipe",
    --         recipe = "asteroid-collector"
    --     },
    --     {
    --         type = "unlock-recipe",
    --         recipe = "crusher"
    --     },
    --     {
    --         type = "unlock-recipe",
    --         recipe = "metallic-asteroid-crushing"
    --     },
    --     {
    --         type = "unlock-recipe",
    --         recipe = "carbonic-asteroid-crushing"
    --     },
    --     {
    --         type = "unlock-recipe",
    --         recipe = "oxide-asteroid-crushing"
    --     },
    --     {
    --         type = "unlock-recipe",
    --         recipe = "cargo-bay"
    --     }
    -- },
end

return Module
