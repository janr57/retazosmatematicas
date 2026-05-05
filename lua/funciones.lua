-- funciones.lua

local M = {} -- módulo definido para mantener el orden

function M.puntos(esf, obs, ptos)
   tex.print("\\begin{tikzpicture}[scale=1.9]")

--    1. ESFERA
   tex.print(string.format(
		"\\shade[ball color = %s, opacity = %4f] (0,0) circle[radius=%4f];",
		esf.sombracolor, esf.sombraopacidad, esf.radio
   ))
   tex.print(string.format(
		"\\draw[%s] (0,0) circle[radius=%4f];", esf.color, esf.radio
   ))
   

   tex.print("\\end{tikzpicture}")   
   
end



function M.puntostxt(esfera, vista, puntos)

   -- Decodificar primer parámetro
   tex.print("\\noindent\\textbf{Esfera:}\\\\")
   tex.print("Radio: " .. tostring(esfera.radio) .. ", ")
   tex.print("Color: " .. tostring(esfera.color) .. ", ")
   tex.print("Color sombra: " .. tostring(esfera.sombracolor) .. ", ")
   tex.print("Opacidad sombra: " .. tostring(esfera.sombraopacidad))

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


