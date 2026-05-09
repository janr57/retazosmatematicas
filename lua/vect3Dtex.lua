-- vect3Dtex.lua

local M = {} 

-- ****************************************************************************
-- FUNCIONES DE USUARIO
-- ****************************************************************************
-- (00a) M.TEXpuntos
-- Crea figura tikz con esfera, puntos en la superficie y planos tangentes.
-- Argumentos:
-- esf: Tabla con datos de la esfera.
-- obs: Tabla con datos del observador, o perspectiva de visión de la esfera.
-- ptos: Tabla con los puntos sobre la esfera y objetos relacionados con ellos.
-- Resumen:
-- (esf, obs, ptos) -> Imagen TikZ de esfera con puntos y planos.
function M.TIKZEsferaAll(esf, obs, ptos)
   local visibles
   local invisibles

   visibles, invisibles = M.Visibilidad(obs, ptos)

   
   tex.print("\\begin{tikzpicture}[scale=1.9]")

   -- 1. PUNTOS INVISIBLES
   for i, p in ipairs(invisibles) do
      tex.print(string.format("\\fill[red] (%4f,%4f) circle[radius=0.5pt];",
			      p.u, p.v))
   end
   
   -- 2. ESFERA
   tex.print(string.format(
		"\\draw[%s,opacity=%2.f] (0,0) circle[radius=%.2f];",
		esf.color, esf.opacidad, esf.radio))
   tex.print(string.format(
		"\\shade[ball color = %s, opacity = %4f] (0,0) circle[radius=%.2f];",
		esf.sombracolor, esf.sombraopacidad, esf.radio))

   -- 3. PUNTOS VISIBLES
   for i, p in ipairs(visibles) do
      tex.print(string.format("\\fill[black] (%4f,%4f) circle[radius=0.5pt];",
			      p.u, p.v))
   end

tex.print("\\end{tikzpicture}")
   
end
-- ----------------------------------------------------------------------------

-- (00b) **********************************************************************
-- FUNCIÓN DE USUARIO
-- TEXproy_PRect(x, y, z, obs)
-- Escribe una cadena con las coordenadas u, v del punto en la pantalla.
-- Argumentos:
--     Coordenadas rectangulares x,y,z.
--     Tabla con datos angulares del observador (perspectiva).n
-- Retorna:
--     Cadena con las coordenadas (u,v) de la pantalla: "(u,v)"
function M.TEXproy_PRect(x, y, z, obs)

   -- Crea tabla con las coordenadas rect. y esféricas del punto (grados y rad)
   -- y algunas funciones trigonométricas para ahorrar cálculos.
   PAll = M.R3dToAll(x,y,z)

   -- Crea tabla con las coordenadas esféricas del observador (grados y rad)
   -- y algunas funciones trigonométricas para ahorrar cálculos.
   viewAll = M.SD3dView(obs)

   -- Crea las dos coordenadas del punto en pantalla visto por el observador
   u, v = M.proyPoint(PAll, viewAll)

   return u, v
end


-- ****************************************************************************
-- FUNCIONES AUXILIARES
-- ****************************************************************************
function M.completaPuntos(esf, obs, ptos)
   local proy
   for i, p in ipairs(ptos) do
      u, v = M.sphD2uv(esf.radio, p.thetaD, p.phiD, obs)

      p.u = u
      p.v = v
   end
end

function M.Visibilidad(obs, ptos)
   local visibles = {}
   local invisibles = {}

   for i, pto in ipairs(ptos) do
      if M.esVisible(obs, pto) then
	 table.insert(visibles, pto)
      else
	 table.insert(invisibles, pto)
      end
   end

   return visibles, invisibles
end

function M.esVisible(obs, pto)
   local theta = math.rad(pto.thetaD)
   local phi = math.rad(pto.phiD)
   local otheta = math.rad(obs.thetaD)
   local ophi = math.rad(obs.phiD)
   
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


-- (00c) **********************************************************************
-- FUNCIÓN DE USUARIO
-- sphD2uv(radio, thetaD, phiD, obs)
-- Escribe una cadena con las coordenadas u, v del punto en la pantalla
-- Argumentos:
--    Radio de la esfera.
--    Coordenadas angulares de un punto de la esfera (grados).
--    Tabla de ángulo del observador.
-- Retorna:
--    Cadena con las coordenadas (u,v) de la pantalla: "(u,v)"
function M.sphD2uv(r, thetaD, phiD, obs)
   -- Crea tabla con las coordenadas rect y esféricas del punto (grados y rad)
   -- y algunas funciones trigonométricas para ahorrar cálculos.
   PAll = M.SD3dToAll(r, thetaD, phiD)

   -- Crea tabla con las coordenadas esféricas del observador (grados y rad)
   -- y algunas funciones trigonométricas para ahorrar cálculos.   
   viewAll = M.SD3dView(obs)
   
   -- Crea las dos coordenadas del punto en pantalla visto por el observador
   u, v = M.proyPoint(PAll, viewAll)

   --tex.sprint(string.format("%.4f, %.4f", u, v))
   return u, v
end

-- (02c) **********************************************************************
-- FUNCIÓN AUXILIAR
-- R3dToAll(x,y,z)
-- Transforma coord. rectangulares en esféricas y cálculos preparados.
-- Argumentos: coordenadas rectangulares x, y, z.
-- Retorna: Una tabla P con los valores
-- P.x, P.y, P.z, P.r, P.theta, P.phi, P.thetaD, P.phiD,
-- P.sintheta, P.costheta, P.tantheta, P.sinphi, P.cosphi, P.tanphi
function M.R3dToAll(x,y,z)
   local P = {}
   P.x = x
   P.y = y
   P.z = z
   
   P.r, P.theta, P.phi = R3dToSph(x,y,z)
   
   P.thetaD = math.deg(P.theta)
   P.phiD = math.deg(P.phi)

   P.sintheta = math.sin(P.theta)
   P.costheta = math.cos(P.theta)
   P.tantheta = math.tan(P.theta)
   P.sinphi = math.sin(P.phi)
   P.cosphi = math.cos(P.phi)
   P.tanphi = math.tan(P.phi)

   return P
end


--(03d) SD3dToAll -> Transforma coord. esféricas (grados) en rectangulares
--      con tablas que contienen algunos cálculos trigonométricos.
-- (03d) **********************************************************************
-- SD3dToAll(r,thetaD,phiD)
-- Transforma coord. esféricas (grados) en rectangulares y cálculos trigonom.
-- Argumentos: coordenadas esféricas (grados) r, thetaD y phiD
-- Retorna: Una tabla P con los valores
-- P.x, P.y, P.z, P.r, P.theta, P.phi, P.thetaD, P.phiD,
-- P.sintheta, P.costheta, P.tantheta, P.sinphi, P.cosphi, P.tanphi
-- Ok!
function M.SD3dToAll(r, thetaD, phiD)
   local P = {}
   
   x, y, z = M.SD3dToRect(r, thetaD, phiD)

   P.x = x
   P.y = y
   P.z = z
   
   P.r = r
   P.thetaD = thetaD
   P.phiD = phiD

   P.theta = math.rad(thetaD)
   P.phi = math.rad(phiD)

   P.sintheta = math.sin(P.theta)
   P.costheta = math.cos(P.theta)
   P.tantheta = math.tan(P.theta)
   P.sinphi = math.sin(P.phi)
   P.cosphi = math.cos(P.phi)
   P.tanphi = math.tan(P.phi)

   return P
end


-- (06axx) **********************************************************************
-- FUNCIÓN AUXILIAR
-- SD3dView(obs)
-- Calcula ángulos de vista del observador (grados y rad) y cálc. trig.
-- Argumentos:
-- Tabla de ángulos de vista del observador (grados).
-- Retorna: Una tabla viewAll con los valores de los ángulos y func. trig.
-- viewAll.theta, viewAll.phi, viewAll.thetaD, viewAll.phiD
-- viewAll.sintheta, viewAll.costheta, viewAll.tantheta,
-- viewAll.sinphi, viewAll.cosphi, viewAll.tanphi
function M.SD3dView(obs)
   local viewAll = {}
   viewAll.thetaD = obs.thetaD
   viewAll.phiD= obs.phiD
   viewAll.theta = math.rad(obs.thetaD)
   viewAll.phi = math.rad(obs.phiD)
   viewAll.sintheta = math.sin(viewAll.theta)
   viewAll.costheta = math.cos(viewAll.theta)
   viewAll.tantheta = math.tan(viewAll.theta)
   viewAll.sinphi = math.sin(viewAll.phi)
   viewAll.cosphi = math.cos(viewAll.phi)
   viewAll.tanphi = math.tan(viewAll.phi)
   viewAll.costhetacosphi = math.cos(viewAll.theta) * math.cos(viewAll.phi)
   viewAll.costhetasinphi = math.cos(viewAll.theta) * math.sin(viewAll.phi)

   return viewAll
end

--(03b) SD3dToRect -> Transforma coord. esféricas (grados) a rectangulares.	    
-- (03b) **********************************************************************
-- SD3dToRect(r, thetaD, phiD)
-- Transforma coord. esféricas (grados) en rectangulares.
-- Argumentos: coordenadas esféricas r, thetaD y phiD.
-- Retorna: Coordenadas rectangulares
-- OK!
function M.SD3dToRect(r, thetaD, phiD)
   local x, y, z
   local theta, phi

   theta = math.rad(thetaD)
   phi = math.rad(phiD)
   
   x = r * math.sin(theta) * math.cos(phi)
   y = r * math.sin(theta) * math.sin(phi)
   z = r * math.cos(theta)

   return x, y, z
end



---- (02) *********************************************************************
---- FUNCIÓN AUXILIAR
---- (x,y,z) -> TABLA: P.x  P.y  P.z  P.r  P.theta  P.phi
--function pointRectStrToRect(strRect)
--   local x, y, z
--   local found, last, i
--
---- Buscamos "("
--found, last = strRect:find("%(")
--if not found then
--   return nil
--end
---- Buscamos "," para localizar la coordenada x
--i = last + 1
--found, last = strRect:find(",", i)
--if found then
--   x = tonumber(strRect:sub(i, last-1))
--else
--   return nil
--end
---- Buscamos la segunda "," para localizar la coordenada y
--i = last + 1
--found, last = strRect:find(",", i)
--if found then
--   y = tonumber(strRect:sub(i, last-1))
--else
--   return nil
--end
---- Buscamos ")" para localizar la coordenada z
--i = last + 1
--found, last = strRect:find("%)", i)
--if found then
--   z = tonumber(strRect:sub(i, last-1))
--else
--   return nil
--end
--
--return x, y, z
--end




-- (06a) **********************************************************************
-- FUNCIÓN AUXILIAR
-- proyPoint(P, View)
-- Proyecta punto P en la pantalla según la perspectiva/vista View.
-- Argumentos: Tabla completa con punto P y tabla completa con vista View
-- Retorna: Tabla con las coordenadas (u,v) del punto proyectado en la pantalla
-- PointProy.u, PointProy.v
function M.proyPoint(P, View)
   local u, v
   --local PointProy = {}

   --PointProy.x = P.x
   --PointProy.y = P.y
   --PointProy.z = P.z
   --PointProy.r = P.r
   --PointProy.theta = P.theta
   --PointProy.phi = P.phi
   --PointProy.thetaD = P.thetaD
   --PointProy.phiD = P.phiD

   u = -P.x * View.sinphi + P.y * View.cosphi
   v = -P.x * View.costhetacosphi - P.y * View.costhetasinphi + P.z * View.sintheta

   return u, v
end


-- (02a) **********************************************************************
-- R3dToSph(x,y,z)
-- Transforma coord. rectangulares en esféricas.
-- Argumentos: coordenadas rectangulares x, y, z.
-- Retorna: Coordenadas esféricas (ángulos en radianes).
function M.R3dToSph(x,y,z)
   local rxy = math.sqrt(x^2 + y^2)
   local r = R3dNorm(x,y,z)
   local theta, phi

   -- Se calculan unos ángulos por defecto
   theta = math.acos(z/r)
   phi = math.atan(y/x)

   -- Se modificarán los ángulos por defecto con los condicionales siguientes
   -- No se pregunta por los casos que no modifiquen esos ángulos por defecto
   if x ~= 0 and y ~= 0 and z ~= 0 then
      -- Ninguna coordenada es cero
      if x < 0 and y > 0 and z > 0 then
	 phi = math.pi/2 - phi
      elseif x < 0 and y > 0 and z < 0 then
	 phi = math.pi/2 - phi
      elseif x < 0 and y < 0 and z > 0 then
	 phi = math.pi + phi
      elseif x < 0 and y < 0 and z < 0 then
	 phi = math.pi + phi 
      end
   elseif x == 0 and y ~= 0 and z ~= 0 then
      -- Solo x vale cero
      phi = math.pi/2
      if y < 0 and z > 0 then
	 phi = -phi
      end
   elseif x ~= 0 and y == 0 and z ~= 0 then
      -- Solo y vale cero
      phi = 0
      if x < 0 and z > 0 then
	 phi = math.pi
      elseif x < 0 and z < 0 then
	 phi = -math.pi
      end
   elseif x ~= 0 and y ~= 0 and z == 0 then
      -- Solo z vale cero
      theta = math.pi/2
      if x < 0 and y > 0 then
	 phi = math.pi - phi
      elseif x > 0 and y < 0 then
	 phi = math.pi + phi
      end
   elseif x == 0 and y == 0 and z ~= 0 then
      -- x == y == 0
      phi = 0/0
      if z > 0 then
	 theta = 0
      else
	 theta = math.pi
      end
   elseif x == 0 and y ~= 0 and z == 0 then
      -- x == z == 0
      if y > 0 then
	 theta = math.pi/2	 
           else
	 phi = -math.pi/2
      end
   elseif x ~= 0 and y == 0 and z == 0 then
      -- y == z == 0
      theta = math.pi/2
      phi = 0
      if x > 0 then
	 phi = 0
      else
	 phi = math.pi
      end
   else
      -- x == y == z == 0
      theta = 0/0
      phi = 0/0
   end
   
   return r, theta, phi
end


-- (00a) **********************************************************************
-- R3dMod(x,y,z)
-- Calcula el módulo de un vector expresado en coordenadas rectangulares.
-- Argumentos: coordenadas rectangulares x, y, z.
-- Retorna: Módulo del vector.
function M.R3dNorm(x,y,z)
   
   return math.sqrt(x^2 + y^2 + z^2)
end

-- ****************************************************************************
-- FUNCIONES DE DEPURACIÓN
-- ****************************************************************************
-- (02a)
-- Código de depuración el LuaLaTeX.
-- Resumen de los datos enviados y procesados por LuaLaTeX.
-- Esfera, Observador y puntos visibles e invisibles.
function M.DEBUGesferaTeX(esf)
   -- TABLA ESFERA
   tex.print([[\noindent\,\textbf{ESFERA}\\]])
   tex.print([[\begin{tabular}{|c|c|c|c|c|}]])
   tex.print([[\hline]])
   tex.print([[Radio & Color & Opacidad & Color de sombra & Opacidad de sombra \\]])
   tex.print([[\hline]])
   tex.print(string.format(
		[[ %.2f & %s & %.2f & %s & %.2f\\ ]],
         esf.radio, esf.color, esf.opacidad, esf.sombracolor, esf.sombraopacidad
   ))
   tex.print([[\hline]])
   tex.print([[\end{tabular}]])

end

function M.DEBUGobservadorTeX(obs)
   -- TABLA OBSERVADOR
   tex.print([[\\]])
   --tex.print([[\\]])
   
   tex.print([[\noindent\,\textbf{OBSERVADOR}\\]])
   tex.print([[\begin{tabular}{|c|c|}]])
   tex.print([[\hline]])
   tex.print([[$\theta$ & $\phi$\\]])
   tex.print([[\hline]])
   tex.print(string.format(
	[[ \qty{%.2f}{\degree} & \qty{%.2f}{\degree}\\ ]],
		obs.thetaD, obs.phiD
   ))
   tex.print([[\hline]])
   tex.print([[\end{tabular}]])
end

function M.DEBUGpuntosTeX(ptos)
   -- TABLA PUNTOS   
   tex.print([[\\]])
   --tex.print([[\\]])
   
   tex.print([[\noindent\,\textbf{PUNTOS}\\]])
   tex.print([[\begin{tabular}{|c|c|c|c|c|c|c|}]])
   tex.print([[\hline]])
   tex.print([[ID&$\theta$&$\phi$&$a$&$b$&Opacidad&Color\\]])
   tex.print([[\hline]])

   for i, p in ipairs(ptos) do
      tex.print(string.format(
       [[%d&\qty{%.2f}{\degree}&\qty{%.2f}{\degree}&%.2f&%.2f&%.2f&%s\\]],
   	  i, p.thetaD, p.phiD, p.a, p.b, p.opacidad, p.color))
   end
   tex.print([[\hline]])
   tex.print([[\end{tabular}]])
   tex.print([[\\]])
end

function M.DEBUGpuntosAllTeX(esf, obs, ptos)
   local visibles
   local invisibles

    visibles, invisibles = M.Visibilidad(obs, ptos)

   -- Decodificar primer parámetro
   tex.print("\\noindent\\textbf{Esfera:}\\\\")
   tex.print("Radio: " .. tostring(esf.radio) .. ", ")
   tex.print("Color: " .. tostring(esf.color) .. ", ")
   tex.print("Color sombra: " .. tostring(esf.sombracolor) .. ", ")
   tex.print("Opacidad sombra: " .. tostring(esf.sombraopacidad))

   -- Decodificar segundo parámetro
   tex.print("\\\\\\textbf{Observador:}\\\\")
   tex.print("$\\theta$: " .. tostring(obs.thetaD) .. ", ")
   tex.print("$\\phi$: " .. tostring(obs.phiD))
   

   -- Decodificar matriz de puntos
   tex.print("\\\\\\textbf{Listado de puntos y planos:}\\\\")
   
   -- Iterar sobre la matriz de puntos
   -- i es el índice, p es la tabla de cada punto
   for i, p in ipairs(ptos) do
      tex.print(string.format(
	"Punto %d: $\\theta$=%s, $\\phi$=%s | Plano %sx%s | Color: %s | %s  %s\\\\",
          i, p.thetaD, p.phiD, p.a, p.b, p.color, p.u, p.v))

   end
   tex.print("\\\\\\textbf{Listado de puntos y planos visibles:}\\\\")      
   for i, v in ipairs(visibles) do
      tex.print(string.format(
	   "Punto %d: $\\theta$=%s, $\\phi$=%s | Plano %sx%s | Color: %s\\\\",
          i, v.thetaD, v.phiD, v.a, v.b, v.color))
   end

   tex.print("\\\\\\textbf{Listado de puntos y planos invisibles:}\\\\")      
   for i, v in ipairs(invisibles) do
      tex.print(string.format(
	"Puntos %d: $\\theta$=%s, $\\phi$=%s | Plano %sx%s | Color: %s\\\\",
          i, v.thetaD, v.phiD, v.a, v.b, v.color
      ))
   end
end
-- ----------------------------------------------------------------------------

-- (02b)
-- M.DEBUGpuntosLua
-- Còdigo de depuración en lua.
-- Imprime en Lua un resumen de los datos enviados por Lua.
-- Esfera, Observador y puntos visibles e invisibles.
function M.DEBUGpuntosLua(esf, obs, ptos)
   local visibles
   local invisibles

    visibles, invisibles = M.Visibilidad(obs, ptos)

   -- Decodificar primer parámetro
   print("Esfera:}")
   print("Radio: " .. tostring(esf.radio) .. ", ")
   print("Color: " .. tostring(esf.color) .. ", ")
   print("Color sombra: " .. tostring(esf.sombracolor) .. ", ")
   print("Opacidad sombra: " .. tostring(esf.sombraopacidad))

   -- Decodificar segundo parámetro
   print("Observador:")
   print("theta: " .. tostring(obs.thetaD) .. ", ")
   print("phi: " .. tostring(obs.phiD))
   

   -- Decodificar matriz de puntos
   print("Listado de puntos y planos:")
   
   -- Iterar sobre la matriz de puntos
   -- i es el índice, p es la tabla de cada punto
   for i, p in ipairs(ptos) do
      print(string.format(
	"Punto %d: theta=%s, phi=%s | Plano %sx%s | Color: %s",
          i, p.thetaD, p.phiD, p.a, p.b, p.color
      ))

   end
   print("Listado de puntos y planos visibles:")      
   for i, vis in ipairs(visibles) do
      print(string.format(
	"Puntos %d: theta$=%s, phi=%s | Plano %sx%s | Color: %s",
          i, vis.thetaD, vis.phiD, vis.a, vis.b, vis.color
      ))      
   end

   print("Listado de puntos y planos invisibles:")      
   for i, inv in ipairs(invisibles) do
      print(string.format(
	"Puntos %d: theta=%s, phi=%s | Plano %sx%s | Color: %s",
          i, inv.thetaD, inv.phiD, inv.a, inv.b, inv.color
      ))      
   end
end


return M



