-- calculos.lua
function polar_to_cartesian(r, theta)
    -- Calculamos las coordenadas cartesianas
    local x = r * math.cos(theta)
    local y = r * math.sin(theta)
    
    -- tex.print envía el texto directamente al flujo de entrada de LaTeX
    -- El formato "(x,y)" es el que TikZ entiende como coordenada
    tex.print(string.format("(%.4f, %.4f)", x, y))
end
