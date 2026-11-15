return {
    -- Utilitários compartilhados
    ["shared.control-animations"] = require("shared.control-animations"),
    ["shared.control-utils"] = require("shared.control-utils"),
    ["shared.control-ambent-effects"] = require("shared.control-ambent-effects"),
    ["shared.control-energy-sources"] = require("shared.control-energy-sources"),
    ["shared.tech-util"] = require("shared.tech-util"),
    ["shared.control-get-mod-path"] = require("shared.control-get-mod-path"),
    ["shared.planet-surface-properties"] = require("shared.planet-surface-properties"),
    ["shared.planet-mapgen-util"] = require("shared.planet-mapgen-util"),

    -- Itens
    ["data-stage.builders.items.base"] = require("data-stage.builders.items.base"),
    ["data-stage.builders.items.item"] = require("data-stage.builders.items.item"),
    ["data-stage.builders.items.ore-item"] = require("data-stage.builders.items.ore-item"),
    ["data-stage.builders.items.block-item"] = require("data-stage.builders.items.block-item"),
    ["data-stage.builders.items.equipment-item"] = require("data-stage.builders.items.equipment-item"),
    ["data-stage.builders.items.item-group"] = require("data-stage.builders.items.item-group"),
    ["data-stage.builders.items.item-search"] = require("data-stage.builders.items.item-search"),

    -- Fluidos
    ["data-stage.builders.fluids.base"] = require("data-stage.builders.fluids.base"),
    ["data-stage.builders.fluids.fluid"] = require("data-stage.builders.fluids.fluid"),
    ["data-stage.builders.fluids.gas"] = require("data-stage.builders.fluids.gas"),

    -- Entidades
    ["data-stage.builders.entities.base"] = require("data-stage.builders.entities.base"),
    ["data-stage.builders.entities.entity"] = require("data-stage.builders.entities.entity"),
    ["data-stage.builders.entities.accumulator"] = require("data-stage.builders.entities.accumulator"),

    -- Tecnologias
    ["data-stage.builders.technologies.base"] = require("data-stage.builders.technologies.base"),
    ["data-stage.builders.technologies.technology"] = require("data-stage.builders.technologies.technology"),
    ["data-stage.builders.technologies.trigger"] = require("data-stage.builders.technologies.trigger"),
    ["data-stage.builders.technologies.trigger-craft"] = require("data-stage.builders.technologies.trigger-craft"),
    ["data-stage.builders.technologies.trigger-mine"] = require("data-stage.builders.technologies.trigger-mine"),

    -- Receitas
    ["data-stage.builders.recipes.base"] = require("data-stage.builders.recipes.base"),
    ["data-stage.builders.recipes.recipe"] = require("data-stage.builders.recipes.recipe"),
    ["data-stage.builders.recipes.format-results"] = require("data-stage.builders.recipes.format-results"),

    -- Compósitos
    ["data-stage.builders.composites.base"] = require("data-stage.builders.composites.base"),
    ["data-stage.builders.composites.item-with-recipe"] = require("data-stage.builders.composites.item-with-recipe"),
    ["data-stage.builders.composites.block-item-with-recipe"] = require("data-stage.builders.composites.block-item-with-recipe"),
    ["data-stage.builders.composites.equipment-item-with-recipe"] = require("data-stage.builders.composites.equipment-item-with-recipe"),
    ["data-stage.builders.composites.fluid-with-recipe"] = require("data-stage.builders.composites.fluid-with-recipe"),
    ["data-stage.builders.composites.generic-recipe"] = require("data-stage.builders.composites.generic-recipe"),
    ["data-stage.builders.composites.category-machines"] = require("data-stage.builders.composites.category-machines"),
    ["data-stage.builders.composites.throw-in-water"] = require("data-stage.builders.composites.throw-in-water"),

    -- Mundo e Recursos
    ["data-stage.builders.world.autoplace-control"] = require("data-stage.builders.world.autoplace-control"),
    ["data-stage.builders.world.resource"] = require("data-stage.builders.world.resource"),
    ["data-stage.builders.world.ore"] = require("data-stage.builders.world.ore"),
    ["data-stage.builders.world.planet"] = require("data-stage.builders.world.planet"),
    ["data-stage.builders.world.space-connection"] = require("data-stage.builders.world.space-connection")
}
