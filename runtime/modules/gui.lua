local GuiUtils = {}

--- Formata um valor em Joules para uma string legível com unidade apropriada (J, kJ, MJ, GJ, TJ, PJ).
---
--- @param joules number Quantidade de energia em Joules
--- @param decimals number|nil Número de casas decimais (padrão: 1)
--- @return string Ex: "5.2 MJ", "300.0 kJ"
function GuiUtils.formatEnergy(joules, decimals)
    if not joules or type(joules) ~= "number" then return "0 J" end
    local dec = decimals or 1
    local fmt = "%." .. tostring(dec) .. "f %s"

    local abs_j = math.abs(joules)
    if abs_j >= 1e15 then
        return string.format(fmt, joules / 1e15, "PJ")
    elseif abs_j >= 1e12 then
        return string.format(fmt, joules / 1e12, "TJ")
    elseif abs_j >= 1e9 then
        return string.format(fmt, joules / 1e9, "GJ")
    elseif abs_j >= 1e6 then
        return string.format(fmt, joules / 1e6, "MJ")
    elseif abs_j >= 1e3 then
        return string.format(fmt, joules / 1e3, "kJ")
    else
        return string.format("%d J", math.floor(joules))
    end
end

--- Formata um valor em Watts para uma string legível de potência (W, kW, MW, GW, TW).
---
--- @param watts number Potência em Watts
--- @param decimals number|nil Número de casas decimais (padrão: 1)
--- @return string Ex: "500.0 kW", "10.5 MW"
function GuiUtils.formatPower(watts, decimals)
    if not watts or type(watts) ~= "number" then return "0 W" end
    local dec = decimals or 1
    local fmt = "%." .. tostring(dec) .. "f %s"

    local abs_w = math.abs(watts)
    if abs_w >= 1e12 then
        return string.format(fmt, watts / 1e12, "TW")
    elseif abs_w >= 1e9 then
        return string.format(fmt, watts / 1e9, "GW")
    elseif abs_w >= 1e6 then
        return string.format(fmt, watts / 1e6, "MW")
    elseif abs_w >= 1e3 then
        return string.format(fmt, watts / 1e3, "kW")
    else
        return string.format("%d W", math.floor(watts))
    end
end

--- Busca recursiva segura de um elemento de GUI por nome dentro de uma hierarquia de containers.
--- Resolve a limitação nativa do Factorio, que só pesquisa filhos de primeiro nível.
---
--- @param root_element LuaGuiElement Elemento raiz onde a busca iniciará
--- @param name string Nome do elemento buscado
--- @param max_depth number|nil Profundidade máxima de busca para proteção (padrão: 32)
--- @return LuaGuiElement|nil Retorna o elemento encontrado ou nil
function GuiUtils.findElementByName(root_element, name, max_depth)
    if not root_element or not root_element.valid or not name or name == "" then
        return nil
    end

    if root_element.name == name then
        return root_element
    end

    local limit = max_depth or 32

    local function search(element, depth)
        if depth > limit then return nil end

        local children = element.children
        if not children or #children == 0 then return nil end

        -- 1. Primeiro varre os filhos diretos do nível atual (busca em largura)
        for _, child in ipairs(children) do
            if child.valid and child.name == name then
                return child
            end
        end

        -- 2. Se não encontrar no nível atual, desce nos netos recursivamente
        for _, child in ipairs(children) do
            if child.valid then
                local found = search(child, depth + 1)
                if found then
                    return found
                end
            end
        end

        return nil
    end

    return search(root_element, 1)
end

--- Busca recursiva de todos os elementos de um determinado tipo dentro de um container.
---
--- @param root_element LuaGuiElement Container raiz
--- @param element_type string Tipo de elemento (ex: "button", "textfield", "table", "progressbar")
--- @param max_depth number|nil Profundidade máxima (padrão: 32)
--- @return LuaGuiElement[] Lista com os elementos encontrados
function GuiUtils.findElementsByType(root_element, element_type, max_depth)
    if not root_element or not root_element.valid or not element_type then
        return {}
    end

    local limit = max_depth or 32
    local results = {}

    local function search(element, depth)
        if depth > limit then return end

        local children = element.children
        if not children then return end

        for _, child in ipairs(children) do
            if child.valid then
                if child.type == element_type then
                    table.insert(results, child)
                end
                search(child, depth + 1)
            end
        end
    end

    search(root_element, 1)
    return results
end

--- Cria uma barra de título padrão com suporte a arrastar a janela e botão de fechar.
---
--- @param frame LuaGuiElement Janela (frame) principal onde o titlebar será inserido
--- @param title LocalisedString|string Título da janela
--- @param close_button_name string|nil Nome do botão de fechar (padrão: "close_btn")
--- @param options table|nil Opções adicionais {hide_close = boolean, tooltip = string}
--- @return table {flow = LuaGuiElement, title_label = LuaGuiElement, close_button = LuaGuiElement|nil}
function GuiUtils.createTitlebar(frame, title, close_button_name, options)
    options = options or {}
    local btn_name = close_button_name or "close_btn"

    local title_flow = frame.add({
        type = "flow",
        direction = "horizontal",
        name = "titlebar_flow"
    })
    title_flow.drag_target = frame

    local title_label = title_flow.add({
        type = "label",
        name = "title_label",
        caption = title,
        style = "frame_title",
        ignored_by_interaction = true
    })

    local drag_widget = title_flow.add({
        type = "empty_widget",
        style = "draggable_space_header",
        ignored_by_interaction = true
    })
    drag_widget.drag_target = frame
    drag_widget.style.horizontally_stretchable = true
    drag_widget.style.left_margin = 8
    drag_widget.style.right_margin = 8
    drag_widget.style.height = 24

    local close_btn = nil
    if not options.hide_close then
        close_btn = title_flow.add({
            type = "sprite-button",
            name = btn_name,
            style = "frame_action_button",
            sprite = "utility/close",
            hovered_sprite = "utility/close_black",
            clicked_sprite = "utility/close_black",
            tooltip = options.tooltip or {"gui.close"}
        })
    end

    return {
        flow = title_flow,
        title_label = title_label,
        drag_widget = drag_widget,
        close_button = close_btn
    }
end

--- Cria uma janela modal ou painel padronizado no `player.gui.screen`.
--- Vincula automaticamente ao ciclo de vida do jogador (`player.opened = frame`),
--- permitindo que a tecla ESC / E feche a janela disparando `defines.events.on_gui_closed`.
---
--- @param player LuaPlayer Jogador que abrirá a janela
--- @param name string Nome identificador único da janela
--- @param title LocalisedString|string Título da janela
--- @param options table|nil {
---   width = number|nil,
---   height = number|nil,
---   auto_center = boolean|nil (padrão: true),
---   open_for_player = boolean|nil (padrão: true),
---   close_button_name = string|nil,
---   hide_close = boolean|nil,
---   content_style = string|nil (padrão: "inside_shallow_frame_with_padding"),
---   recreate = boolean|nil (se true, fecha a janela anterior se já existir; padrão: true)
--- }
--- @return table {frame = LuaGuiElement, content = LuaGuiElement, titlebar = table}
function GuiUtils.createWindow(player, name, title, options)
    if not player or not player.valid or not name then
        return nil
    end

    options = options or {}
    local screen = player.gui.screen

    -- Destrói janela existente com o mesmo nome se configurado para recriar
    if options.recreate ~= false and screen[name] and screen[name].valid then
        screen[name].destroy()
    end

    local frame = screen.add({
        type = "frame",
        name = name,
        direction = "vertical"
    })

    if options.auto_center ~= false then
        frame.auto_center = true
    end

    if options.width then
        frame.style.width = options.width
    end
    if options.height then
        frame.style.height = options.height
    end

    -- Criação da barra de título arrastável com botão de fechar
    local close_name = options.close_button_name or (name .. "_close_btn")
    local titlebar = GuiUtils.createTitlebar(frame, title, close_name, {
        hide_close = options.hide_close,
        tooltip = options.close_tooltip
    })

    -- Container principal de conteúdo interno da janela
    local content_style = options.content_style or "inside_shallow_frame_with_padding"
    local content = frame.add({
        type = "frame",
        name = "window_content",
        style = content_style,
        direction = "vertical"
    })
    content.style.vertically_stretchable = true
    content.style.horizontally_stretchable = true

    -- Vincula o frame ao player.opened para fechar no ESC / E
    if options.open_for_player ~= false then
        player.opened = frame
    end

    return {
        frame = frame,
        content = content,
        titlebar = titlebar
    }
end

--- Obtém uma janela aberta pelo nome no `player.gui.screen`.
---
--- @param player LuaPlayer
--- @param name string
--- @return LuaGuiElement|nil
function GuiUtils.getWindow(player, name)
    if not player or not player.valid or not name then return nil end
    local w = player.gui.screen[name]
    return (w and w.valid) and w or nil
end

--- Fecha uma janela com segurança, limpando o `player.opened` correspondente.
---
--- @param player LuaPlayer
--- @param window_or_name LuaGuiElement|string
--- @return boolean True se foi fechada com sucesso
function GuiUtils.closeWindow(player, window_or_name)
    if not player or not player.valid or not window_or_name then
        return false
    end

    local frame = nil
    if type(window_or_name) == "string" then
        frame = player.gui.screen[window_or_name]
    else
        local ok, is_valid = pcall(function() return window_or_name.valid end)
        if ok and is_valid then
            frame = window_or_name
        end
    end

    if not frame or not frame.valid then
        return false
    end

    if player.opened == frame then
        player.opened = nil
    end

    frame.destroy()
    return true
end

--- Alterna a abertura de uma janela: se já estiver aberta, fecha; caso contrário, abre através de `create_fn`.
---
--- @param player LuaPlayer
--- @param window_name string
--- @param create_fn function Função de callback chamada para criar a janela: create_fn(player)
--- @return boolean True se foi aberta, false se foi fechada
function GuiUtils.toggleWindow(player, window_name, create_fn)
    local existing = GuiUtils.getWindow(player, window_name)
    if existing then
        GuiUtils.closeWindow(player, existing)
        return false
    else
        if create_fn then
            create_fn(player)
        end
        return true
    end
end

--- Cria uma barra de status de energia completa (ProgressBar + Label com porcentagem e valores formatados).
---
--- @param parent LuaGuiElement Container onde a barra será inserida
--- @param options table|nil {
---   name = string|nil,
---   width = number|nil (padrão: 200),
---   initial_value = number|nil (padrão: 0),
---   max_value = number|nil (padrão: 1),
---   show_label = boolean|nil (padrão: true),
---   label_caption_pattern = string|nil,
---   bar_style = string|nil
--- }
--- @return table {container = LuaGuiElement, progressbar = LuaGuiElement, label = LuaGuiElement|nil, update = function}
function GuiUtils.createEnergyBar(parent, options)
    if not parent or not parent.valid then return nil end
    options = options or {}

    local flow = parent.add({
        type = "flow",
        name = options.name or "energy_bar_flow",
        direction = "vertical"
    })
    flow.style.horizontally_stretchable = true

    local bar_width = options.width or 200
    local max_val = math.max(1, options.max_value or 1)
    local cur_val = math.max(0, options.initial_value or 0)
    local ratio = math.min(1.0, cur_val / max_val)

    local pbar = flow.add({
        type = "progressbar",
        name = "energy_progressbar",
        style = options.bar_style or "electric_progressbar",
        value = ratio
    })
    pbar.style.width = bar_width
    pbar.style.horizontally_stretchable = true

    local lbl = nil
    if options.show_label ~= false then
        local pct = ratio * 100
        local txt = string.format("%s / %s (%.1f%%)", GuiUtils.formatEnergy(cur_val), GuiUtils.formatEnergy(max_val), pct)
        lbl = flow.add({
            type = "label",
            name = "energy_label",
            caption = txt,
            style = "caption_label"
        })
        lbl.style.font = "default-small-bold"
    end

    local result = {
        container = flow,
        progressbar = pbar,
        label = lbl
    }

    --- Atualiza a barra de energia e seu rótulo
    --- @param current number Joules atuais
    --- @param max number Capacidade máxima em Joules
    result.update = function(current, max)
        GuiUtils.updateEnergyBar(pbar, current, max, lbl)
    end

    return result
end

--- Atualiza o valor e texto de uma barra de progresso de energia existente.
---
--- @param progressbar LuaGuiElement Elemento ProgressBar
--- @param current number Joules atuais
--- @param max number Capacidade máxima em Joules
--- @param label LuaGuiElement|nil Elemento Label para atualizar o texto (opcional)
function GuiUtils.updateEnergyBar(progressbar, current, max, label)
    if not progressbar or not progressbar.valid then return end

    local max_val = math.max(1, max or 1)
    local cur_val = math.max(0, current or 0)
    local ratio = math.min(1.0, cur_val / max_val)

    progressbar.value = ratio

    if label and label.valid then
        local pct = ratio * 100
        label.caption = string.format("%s / %s (%.1f%%)", GuiUtils.formatEnergy(cur_val), GuiUtils.formatEnergy(max_val), pct)
    end
end

--- Destrói todos os elementos filhos de um container de GUI.
---
--- @param container LuaGuiElement Container a ser esvaziado
function GuiUtils.clearChildren(container)
    if not container or not container.valid then return end
    local children = container.children
    if children then
        for _, child in ipairs(children) do
            if child.valid then
                child.destroy()
            end
        end
    end
end

return GuiUtils

