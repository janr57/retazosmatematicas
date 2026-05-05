-- funciones.lua

local M = {} -- módulo definido para mantener el orden

function M.puntos(esfera, vista, puntos)
   tex.print("\\begin{tikzpicture}[scale=0.5]")

--    1. ESFERA
   tex.print("\\draw (0,0) circle[radius=1cm];")

   tex.print("\\end{tikzpicture}")   
   
end

function M.puntostxt(esfera, vista, puntos)

   -- Decodificar primer parámetro
   tex.print("\\noindent\\textbf{Esfera:}\\\\")
   tex.print("Radio: " .. tostring(esfera.radio) .. ", ")
   tex.print("Opacidad: " .. tostring(esfera.opacidad))

   -- Decodificar segundo parámetro
   tex.print("\\\\\\textbf{Vista:}\\\\")   
   tex.print("Theta: " .. tostring(vista.theta) .. ", ")
   tex.print("Phi: " .. tostring(vista.phi))
   

   -- Decodificar matriz de puntos
   tex.print("\\\\\\textbf{Listado de puntos y planos:}\\\\")
   
   -- Iterar sobre la matriz de puntos
   -- i es el índice, p es la tabla de cada punto
   for i, p in ipairs(puntos) do
      tex.print(string.format(
	"Punto %d: $\\theta$=%s, $\\phi$=%s | Plano %sx%s | Color: %s\\\\",
          i, p.theta, p.phi, p.a, p.b, p.color
      ))

   end
end

return M



