-- funciones.lua

local M = {} -- módulo definido para mantener el orden


function M.puntos(esf, obs, ptos)
   --local visibles =  {}
   --local invisibles = {}

   --visibles, invisibles = M.Visibilidad(obs, ptos)
   
   tex.print("\\begin{tikzpicture}[scale=1.9]")

--    1. ESFERA
   tex.print(string.format(
		"\\shade[ball color = %s, opacity = %4f] (0,0) circle[radius=%4f];",
		esf.sombracolor, esf.sombraopacidad, esf.radio))
   tex.print(string.format(
		"\\draw[%s] (0,0) circle[radius=%4f];", esf.color, esf.radio))

   tex.print("\\end{tikzpicture}")   
   
end


-- Imprime un resumen de los datos enviados por LuaLaTeX
-- Esfera, Observador y puntos visibles e invisibles
function M.puntostxt(esf, obs, ptos)
   local visibles = {}
   local invisibles = {}

    visibles, invisibles = M.Visibilidad(obs, ptos)

   -- Decodificar primer parámetro
   tex.print("\\noindent\\textbf{Esfera:}\\\\")
   tex.print("Radio: " .. tostring(esf.radio) .. ", ")
   tex.print("Color: " .. tostring(esf.color) .. ", ")
   tex.print("Color sombra: " .. tostring(esf.sombracolor) .. ", ")
   tex.print("Opacidad sombra: " .. tostring(esf.sombraopacidad))

   -- Decodificar segundo parámetro
   tex.print("\\\\\\textbf{Observador:}\\\\")
   tex.print("Theta: " .. tostring(obs.theta) .. ", ")
   tex.print("Phi: " .. tostring(obs.phi))
   

   -- Decodificar matriz de puntos
   tex.print("\\\\\\textbf{Listado de puntos y planos:}\\\\")
   
   -- Iterar sobre la matriz de puntos
   -- i es el índice, p es la tabla de cada punto
   for i, p in ipairs(ptos) do
      tex.print(string.format(
	"Punto %d: $\\theta$=%s, $\\phi$=%s | Plano %sx%s | Color: %s\\\\",
          i, p.theta, p.phi, p.a, p.b, p.color
      ))

   end
   tex.print("\\\\\\textbf{Listado de puntos y planos visibles:}\\\\")      
   for i, v in ipairs(visibles) do
      tex.print(string.format(
	"Puntos %d: $\\theta$=%s, $\\phi$=%s | Plano %sx%s | Color: %s\\\\",
          i, v.theta, v.phi, v.a, v.b, v.color
      ))      
   end

   tex.print("\\\\\\textbf{Listado de puntos y planos invisibles:}\\\\")      
   for i, v in ipairs(invisibles) do
      tex.print(string.format(
	"Puntos %d: $\\theta$=%s, $\\phi$=%s | Plano %sx%s | Color: %s\\\\",
          i, v.theta, v.phi, v.a, v.b, v.color
      ))      
   end
end


function M.Visibilidad(obs, ptos)
   local visibles = {}
   local invisibles = {}

   for i, pto in ipairs(ptos) do
      if M.esVisible(obs, pto) then
      --if i % 2 == 0 then
	 table.insert(visibles, pto)
      else
	 table.insert(invisibles, pto)
      end
   end

   return visibles, invisibles
end

function M.esVisible(obs, pto)
   local theta = math.rad(pto.theta)
   local phi = math.rad(pto.phi)
   local otheta = math.rad(obs.theta)
   local ophi = math.rad(obs.phi)
   
   local sintheta = math.sin(theta)
   local costheta = math.cos(theta)
   local sinphi = math.sin(phi)
   local cosphi = math.cos(phi)
   
   local osintheta = math.sin(otheta)
   local ocostheta = math.cos(otheta)
   local osinphi = math.sin(ophi)
   local ocosphi = math.cos(ophi)

   if sintheta * osintheta * math.cos(phi-ophi) + costheta * ocostheta >= 0 then
      return true
   else
      return false
   end
end


return M


