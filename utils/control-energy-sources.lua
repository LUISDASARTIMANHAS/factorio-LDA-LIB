-- control-energy-sources.lua
local Module = {}
local utils = require("utils.control-utils")

--- Cria uma PipeConnectionDefinition (conexão de tubo) para uso em FluidBox.
-- @param flow_direction (string, optional) Ex: "input", "output", "input-output". Padrão: "input-output".
-- @param direction (defines.direction, optional) Direção primária (obrigatório para normal/underground). Ex: defines.direction.north.
-- @param position (MapPosition, optional) Posição relativa ao centro da entidade. Ex: {0, 1}.
-- @param connection_type (string, optional) Tipo de conexão. Padrão: "normal". Opções: "normal", "underground", "linked".
-- @param params (table, optional) Parâmetros adicionais (connection_category, max_underground_distance, etc.).
-- @return (table) PipeConnectionDefinition
function Module.createPipeConnection(
    flow_direction,
    direction,
    position,
    connection_type, -- Permite fácil mudança para "underground" ou "linked"
    params)
    -- 1. Cria a tabela base da Pipe Connection.
    local connection = {
        -- flow_direction (Essencial)
        -- Padrão: "input-output" se omitido, mas é bom forçar o usuário a pensar nisso.
        flow_direction = flow_direction or "input-output",
        -- connection_type (Padrão: "normal")
        connection_type = connection_type or "normal"
    }

    -- 2. Adiciona campos obrigatórios para conexões "normal" e "underground".

    if connection.connection_type == "normal" or connection.connection_type == "underground" then
        -- direction (Obrigatório para normal/underground)
        -- Ex: defines.direction.north, defines.direction.east, etc.
        if direction == nil then
            -- Note: Se o 'direction' for nil, o Factorio pode reclamar em conexões "normal".
            log("LDA-LIB WARN: Pipe connection do tipo 'normal' ou 'underground' criado sem 'direction'.")
        end
        connection.direction = direction

        -- position (Obrigatório para normal/underground, a menos que use 'positions')
        -- Ex: {0, 1}
        if position == nil then
            log("LDA-LIB WARN: Pipe connection do tipo 'normal' ou 'underground' criado sem 'position'.")
        end
        connection.position = position
    end

    -- 3. Mescla os parâmetros adicionais (params) CONDICIONALMENTE.
    -- Isso permite adicionar connection_category, max_underground_distance, positions, etc.
    connection = utils.tableMerge(connection, params)

    -- 4. Validação para o tipo "linked"
    if connection.connection_type == "linked" and not connection.linked_connection_id then
        log("LDA-LIB ERROR: Pipe connection do tipo 'linked' requer 'linked_connection_id'.")
    end

    -- -- usage
    -- local defines = require("defines")

    -- local connection_entrada = utilsEnergySource.createPipeConnection(
    --     "input",                            -- flow_direction
    --     defines.direction.north,            -- direction
    --     {0, -1}                             -- position (no topo)
    -- )

    -- local connection_saida = utilsEnergySource.createPipeConnection(
    --     "output",                           -- flow_direction
    --     defines.direction.south,            -- direction
    --     {0, 1}                              -- position (em baixo)
    -- )

    -- local minha_fluid_box = utilsEnergySource.createFluidBox(
    --     1000,                                -- volume
    --     "steam",                            -- filter
    --     "input-output",                     -- production_type
    --     {connection_entrada, connection_saida} -- pipe_connections
    -- )

    return connection
end

--- Cria uma definição de FluidBox completa.
-- @param volume (FluidAmount, optional) Volume interno do fluido. Padrão: 100.
-- @param filter (FluidID, optional) Filtro de fluido (Ex: "water").
-- @param production_type (ProductionType, optional) Tipo de produção. Padrão: "input-output".
-- @param pipe_connections (array[PipeConnectionDefinition], optional) Array de conexões de tubo.
-- @param pipecoverspictures (Sprite4Way, optional) Sprites para os covers dos tubos. Padrão: pipecoverspictures().
-- @param params (table, optional) Parâmetros adicionais (min/max_temperature, render_layer, etc.).
-- @return (table) FluidBox
function Module.createFluidBox(
    volume,
    filter,
    production_type,
    pipe_connections,
    pipecoverspictures,
    -- Parâmetros opcionais para detalhes visuais, limites, etc.
    params)
    -- Cria a tabela base da FluidBox com os campos essenciais.
    local fluid_box = {
        -- volume (OBRIGATÓRIO, deve ser > 0)
        volume = volume or 100,
        -- pipe_connections (OBRIGATÓRIO, deve ser um array de PipeConnectionDefinition)
        pipe_connections = pipe_connections or {},
        -- filter (Opcional, mas comum)
        -- Define qual fluido é aceito (Ex: "water")
        filter = filter,
        production_type = production_type or "input-output",
        pipe_covers = pipecoverspictures or pipecoverspictures()
    }

    -- Isso permite adicionar render_layer, minimum_temperature, max_pipeline_extent, etc.
    -- Usa utils.tableMerge (assume-se que está no escopo, via require("utils.control-utils")).
    fluid_box = utils.tableMerge(fluid_box, params)

    -- 4. Limpeza e Validação (garante que volume não seja nil)
    if not fluid_box.volume or fluid_box.volume <= 0 then
        log("LDA-LIB ERROR: FluidBox criado com volume inválido (deve ser > 0). Usando volume = 100.")
        fluid_box.volume = 100
    end

    -- Remove o filtro se for nil, para manter a tabela limpa
    if fluid_box.filter == nil then
        fluid_box.filter = nil
    end

    return fluid_box
end

-- Função auxiliar interna para criar a BaseEnergySource
--- Cria a estrutura base de uma EnergySource com as propriedades de poluição e ícones.
-- @param emissions_per_minute (dictionary[AirbornePollutantID -> double], optional) Poluição por minuto.
-- @param render_no_power_icon (boolean, optional) Padrão: true.
-- @param render_no_network_icon (boolean, optional) Padrão: true.
-- @return (table) BaseEnergySource
local function createBaseSource(emissions_per_minute, render_no_power_icon, render_no_network_icon)
    local source = {
        emissions_per_minute = emissions_per_minute or nil,
        render_no_power_icon = render_no_power_icon or true,
        render_no_network_icon = render_no_network_icon or true
    }
    return source
end

--- Cria uma fonte de energia do tipo "burner" (queimador de item).
-- @param fuel_inventory_size (uint32, optional) Slots de inventário de combustível. Padrão: 1.
-- @param effectivity (double, optional) Eficiência do consumo de combustível. Padrão: 1.0.
-- @param fuel_categories (array[string], optional) Categorias de combustível aceitas. Padrão: {"chemical"}.
-- @param emissions_per_minute (dictionary, optional) Poluição por minuto (BaseSource).
-- @param render_no_power_icon (boolean, optional) (BaseSource).
-- @param render_no_network_icon (boolean, optional) (BaseSource).
-- @param params (table, optional) Parâmetros adicionais (smoke, light_flicker, burnt_inventory_size, etc.).
-- @return (table) BurnerEnergySource
function Module.createBurnerEnergySource(
    fuel_inventory_size,
    effectivity,
    fuel_categories,
    emissions_per_minute,
    render_no_power_icon,
    render_no_network_icon,
    params)
    -- 1. Cria a base.
    local base_source = createBaseSource(emissions_per_minute, render_no_power_icon, render_no_network_icon)

    -- Cria a tabela final com os campos Burner.
    local source = {
        type = "burner",
        fuel_inventory_size = fuel_inventory_size or 1,
        effectivity = effectivity or 1.0,
        fuel_categories = fuel_categories or {"chemical"}
    }

    -- Mescla os campos da BaseSource na Source (INCONDICIONALMENTE = true).
    -- Os campos base que foram omitidos (nil) e definidos em base_source serão adicionados/sobrescritos.
    source = utils.tableMerge(source, base_source, true)

    -- Mescla os parâmetros adicionais (params) CONDICIONALMENTE (padrão = false).
    -- Os 'params' só são adicionados se não tiverem sido definidos pelos campos fixos acima.
    source = utils.tableMerge(source, params)

    return source
end

--- Cria uma fonte de energia do tipo "electric" (rede elétrica).
-- @param usage_priority (ElectricUsagePriority, optional) Prioridade de uso (e.g., "secondary-input", "tertiary"). Padrão: "secondary-input".
-- @param buffer_capacity (Energy, optional) Capacidade do buffer de energia (e.g., "5MJ").
-- @param input_flow_limit (Energy, optional) Limite de fluxo de entrada (e.g., "300kW"). Padrão: "300kW".
-- @param output_flow_limit (Energy, optional) Limite de fluxo de saída (e.g., "300kW"). Padrão: "300kW".
-- @param emissions_per_minute (dictionary, optional) Poluição por minuto (BaseSource).
-- @param render_no_power_icon (boolean, optional) (BaseSource).
-- @param render_no_network_icon (boolean, optional) (BaseSource).
-- @param params (table, optional) Parâmetros adicionais (drain, etc.).
-- @return (table) ElectricEnergySource
function Module.createElectricEnergySource(
    usage_priority,
    buffer_capacity,
    input_flow_limit,
    output_flow_limit,
    -- Parâmetros da BaseEnergySource
    emissions_per_minute,
    render_no_power_icon,
    render_no_network_icon,
    -- Parâmetros adicionais e opcionais do electric (input_flow_limit, drain, etc.)
    params)
    -- Cria a base. (Assume-se que 'createBaseSource' está disponível localmente ou via 'utils')
    local base_source = createBaseSource(emissions_per_minute, render_no_power_icon, render_no_network_icon)

    -- Cria a tabela final com os campos Electric.
    local source = {
        type = "electric",
        -- usage_priority (Essencial)
        -- Exemplos comuns: "secondary-input" (máquina), "tertiary" (acumulador), "secondary-output" (gerador)
        usage_priority = usage_priority or "secondary-input",
        -- buffer_capacity (Opcional, mas útil para o construtor)
        -- Deve ser uma string de energia (Ex: "5MJ")
        -- Se não for fornecido, Factorio usa o padrão (geralmente 0J se não for um acumulador/bateria)
        buffer_capacity = buffer_capacity,
        input_flow_limit = input_flow_limit or "300kW",
        output_flow_limit = output_flow_limit or "300kW"
    }

    -- Usa utils.tableMerge, conforme definido no arquivo de utilitários.
    source = utils.tableMerge(source, base_source, true)

    -- Isso permite adicionar input_flow_limit, output_flow_limit, drain, etc.
    source = utils.tableMerge(source, params)

    -- Remove 'buffer_capacity' se for nil, para não forçar {buffer_capacity = nil} no protótipo,
    -- o que é preferível a {buffer_capacity = "0J"} se não for um acumulador.
    if source.buffer_capacity == nil then
        source.buffer_capacity = nil -- Isso remove a chave ao ser serializado (Factorio LUA)
    end

    return source
end

--- Cria uma fonte de energia do tipo "fluid" (combustível líquido ou vapor).
-- @param fluid_volume (FluidAmount, optional) Volume interno do fluido. Padrão: 100.
-- @param fluid_connections (array[PipeConnectionDefinition], optional) Array de conexões de tubo (use Module.createPipeConnection).
-- @param fluid_filter (FluidID, optional) Filtro de fluido.
-- @param effectivity (double, optional) Eficiência. Padrão: 1.0.
-- @param burns_fluid (boolean, optional) Define se o cálculo de energia é baseado no fuel_value do fluido. Padrão: true.
-- @param emissions_per_minute (dictionary, optional) Poluição por minuto (BaseSource).
-- @param render_no_power_icon (boolean, optional) (BaseSource).
-- @param render_no_network_icon (boolean, optional) (BaseSource).
-- @param params (table, optional) Parâmetros adicionais (smoke, light_flicker, maximum_temperature, production_type, etc.).
-- @return (table) FluidEnergySource
function Module.createFluidEnergySource(
    fluid_volume,
    fluid_connections, -- Array de PipeConnectionDefinition
    fluid_filter,
    -- Parâmetros Essenciais do FluidEnergySource
    effectivity,
    burns_fluid,
    -- Parâmetros da BaseEnergySource
    emissions_per_minute,
    render_no_power_icon,
    render_no_network_icon,
    -- Parâmetros adicionais (inclui os do FluidBox e do EnergySource, como 'smoke')
    params)
    -- 1. Cria a base.
    local base_source = createBaseSource(emissions_per_minute, render_no_power_icon, render_no_network_icon)

    -- Os parâmetros de fluido que não foram passados diretamente (como pipe_covers, min/max temp)
    -- serão buscados no 'params' restante.
    local fluid_box =
        Module.createFluidBox(
        fluid_volume,
        fluid_filter,
        nil, -- production_type (usa o padrão do FluidBox, se não estiver em params)
        fluid_connections,
        nil, -- pipecoverspictures (usa o padrão interno)
        params -- O 'params' é passado aqui para carregar as propriedades da FluidBox (e.g., maximum_temperature)
    )

    -- 3. Cria a tabela final com os campos Fluid.
    local source = {
        type = "fluid",
        -- O FluidBox é o campo chave:
        fluid_box = fluid_box,
        -- effectivity (Padrão: 1.0)
        effectivity = effectivity or 1.0,
        -- burns_fluid (Padrão: true)
        burns_fluid = burns_fluid or true,
        -- Padrão sensato
        scale_fluid_usage = true
    }

    source = utils.tableMerge(source, base_source, true)

    -- Note que o 'params' já foi usado acima para o FluidBox, mas usamos de novo
    -- para garantir que campos específicos do EnergySource (como 'smoke') sejam adicionados.
    source = utils.tableMerge(source, params)
    return source
end

--- Cria uma fonte de energia do tipo "heat" (energia térmica nuclear).
-- @param max_temperature (double) Temperatura máxima de trabalho. (Obrigatório)
-- @param specific_heat (Energy) Quantidade de energia por grau (capacidade térmica). (Obrigatório)
-- @param max_transfer (Energy) Taxa máxima de transferência de calor. (Obrigatório)
-- @param default_temperature (double, optional) Temperatura ambiente/padrão. Padrão: 15.
-- @param min_working_temperature (double, optional) Temperatura mínima de trabalho. Padrão: 15.
-- @param emissions_per_minute (dictionary, optional) Poluição por minuto (BaseSource).
-- @param render_no_power_icon (boolean, optional) (BaseSource).
-- @param render_no_network_icon (boolean, optional) (BaseSource).
-- @param params (table, optional) Parâmetros adicionais (connections, heat_picture, heat_glow, min_temperature_gradient, etc.).
-- @return (table) HeatEnergySource
function Module.createHeatEnergySource(
    max_temperature,
    specific_heat,
    max_transfer,
    default_temperature,
    min_working_temperature,
    -- Parâmetros da BaseEnergySource
    emissions_per_minute,
    render_no_power_icon,
    render_no_network_icon,
    -- Parâmetros adicionais e opcionais do heat (conexões, temperaturas mínimas, visuais)
    params)
    -- Cria a base.
    local base_source = createBaseSource(emissions_per_minute, render_no_power_icon, render_no_network_icon)

    local source = {
        type = "heat",
        -- Propriedades Essenciais (Obrigatórias)
        max_temperature = max_temperature, -- Ex: 1000 (para reator)
        specific_heat = specific_heat, -- Ex: "10MJ" (quanto de energia por grau)
        max_transfer = max_transfer, -- Ex: "10GW" (taxa máxima de troca de calor)
        -- Padrões Sensatos
        default_temperature = default_temperature or 15, -- Temperatura ambiente padrão
        min_working_temperature = min_working_temperature or 15, -- Começa a funcionar no padrão
        min_temperature_gradient = 1 -- Padrão de gradiente
    }

    source = utils.tableMerge(source, base_source, true)

    -- Isso permite adicionar: connections, heat_picture, heat_glow, etc.
    source = utils.tableMerge(source, params)

    -- Validação (garante que os campos obrigatórios estejam preenchidos)
    if not source.max_temperature or not source.specific_heat or not source.max_transfer then
        log("LDA-LIB ERROR: HeatEnergySource requer max_temperature, specific_heat e max_transfer.")
    end

    return source
end

--- Cria uma fonte de energia do tipo "void" (sem consumo/produção de energia).
-- @param emissions_per_minute (dictionary, optional) Poluição por minuto (BaseSource).
-- @param render_no_power_icon (boolean, optional) (BaseSource).
-- @param render_no_network_icon (boolean, optional) (BaseSource).
-- @param params (table, optional) Parâmetros adicionais.
-- @return (table) VoidEnergySource
function Module.createVoidEnergySource(emissions_per_minute, render_no_power_icon, render_no_network_icon, params)
    local base_source = createBaseSource(emissions_per_minute, render_no_power_icon, render_no_network_icon)

    local source = {
        type = "void"
    }

    source = utils.tableMerge(source, base_source, true)
    source = utils.tableMerge(source, params)

    return source
end

return Module
