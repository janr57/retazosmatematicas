-- vect3Dtex.lua

local M = {} 

-- ****************************************************************************
-- FUNCIONES DE USUARIO
-- ****************************************************************************
-- (00a) M.TIKZEsferaPlanos
-- Crea figura tikz con esfera, puntos en la superficie y planos tangentes.
-- Argumentos:
-- esf: Tabla con datos de la esfera.
-- obs: Tabla con datos del observador, o perspectiva de visión de la esfera.
-- ptos: Tabla con los puntos sobre la esfera y objetos relacionados con ellos.
-- Resumen:
-- (esf, obs, ptos) -> Imagen TikZ de esfera con puntos y planos.
function M.TIKZEsferaPlanos(escala, esf, obs, ptos, planos)
   --local visibles
   --local invisibles

   --visibles, invisibles = M.Visibilidad(obs, ptos)
   
   tex.print(string.format(
		"\\begin{tikzpicture}[scale=%.2f]", escala))

   -- 1. PUNTOS INVISIBLES
   for i, p in ipairs(ptos) do
      if not p.visible then
	 tex.print(string.format("\\fill[red] (%4f,%4f) circle[radius=0.5pt];",
				 p.u, p.v))
      end
   end
   
   -- 2. ESFERA
   tex.print(string.format(
		"\\draw[%s,opacity=%2.f] (0,0) circle[radius=%.2f];",
		esf.color, esf.opacidad, esf.radio))
   tex.print(string.format(
		"\\shade[ball color = %s, opacity = %4f] (0,0) circle[radius=%.2f];",
		esf.sombracolor, esf.sombraopacidad, esf.radio))

   -- 3. PLANOS VISIBLES
   for i, p in ipairs(planos) do
      if p.visible then
	 tex.print(string.format(
	[[\draw (%.4f,%.4f) -- (%.4f,%.4f) -- (%.4f,%.4f) -- (%.4f,%.4f) -- cycle;]],
        	p[1].u, p[1].v, p[2].u, p[2].v, p[3].u, p[3].v, p[4].u,p[4].v))
      end
   end

   -- 3. PUNTOS VISIBLES
   for i, p in ipairs(ptos) do
      if p.visible then
	 tex.print(string.format("\\fill[black] (%.4f,%.4f) circle[radius=0.8pt];",
				 p.u, p.v))
      end
   end
   
   tex.print("\\end{tikzpicture}")
end
-- ----------------------------------------------------------------------------

-- (00b) **********************************************************************
-- FUNCIÓN DE USUARIO
-- xyz2uvAll(x, y, z, obs)
-- Escribe una cadena con las coordenadas u, v del punto en la pantalla.
-- Argumentos:
--     Coordenadas rectangulares x,y,z.
--     Tabla con datos angulares del observador (perspectiva).n
-- Retorna:
--     Cadena con las coordenadas (u,v) de la pantalla: "(u,v)"
function M.xyz2uvAll(x, y, z, obs)

   -- Crea tabla con las coordenadas rect. y esféricas del punto (grados y rad)
   -- y algunas funciones trigonométricas para ahorrar cálculos.
   PAll = M.xyz2All(x,y,z)

   -- Crea tabla con las coordenadas esféricas del observador (grados y rad)
   -- y algunas funciones trigonométricas para ahorrar cálculos.
   viewAll = M.SD3dView(obs)

   -- Crea las dos coordenadas del punto en pantalla visto por el observador
   u, v = M.All2uv(PAll, viewAll)

   return u, v
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
   u, v = M.All2uv(PAll, viewAll)

   return u, v
end

-- ****************************************************************************
-- FUNCIONES AUXILIARES
-- ****************************************************************************
function M.completaPuntos(esf, obs, ptos)
   local u, v
   local x, y, z
   
   for i, p in ipairs(ptos) do
      p.r = esf.radio
      
      x, y, z = M.sphD2xyz(esf.radio, p.thetaD, p.phiD)
      -- Coordenadas (x,y,z) del punto de la esfera
      p.x = x
      p.y = y
      p.z = z
      
      u, v = M.sphD2uv(esf.radio, p.thetaD, p.phiD, obs)
      -- Coordenadas (u,v) del punto de la esfera, en la pantalla del observador
      p.u = u
      p.v = v
      
      -- Averigua si el punto es visible, debido a la esfera, desde la
      -- perspectiva del observador.
      p.visible =  M.esVisible(obs, p)
   end
end

function M.completaPlanos(obs, ptos, planos)
   local plano, ptosplano, ptojplano
   local theta, phi, stheta, ctheta, sphi, cphi
   -- Coordenadas del punto de referencia (antes de la rotación)
   local px = 1
   local py = 0
   local pz = 0

   for i, p in ipairs(ptos) do
   -- Coordenadas de un punto del plano en el eje x (antes de la rotación)
   local x0, y0, z0
   -- Coordenadas de un punto rotado del plano (en su sitio)
   local x, y, z
   -- Coordenadas de un punto rotado del plano en la pantalla
   local u, v
      
      -- Ángulos de giro phi y theta, junto con cálculos trigonométricos.
      theta = math.rad(p.thetaD)
      phi = math.rad(p.phiD)
      theta, phi = M.nuevoAnguloGiro(theta, phi)
      stheta = math.sin(theta)
      ctheta = math.cos(theta)
      sphi = math.sin(phi)
      cphi = math.cos(phi)

      plano = {}
      ptosplano = {}
      -- Bucle para los cuatro puntos del plano
      for j = 1, 4 do
	 pjplano = {}
	 x0 = px
	 if j == 1 then
	    y0 = py - p.a/2
	    z0 = pz - p.b/2
	 elseif j == 2 then
	    y0 = py + p.a/2
	    z0 = pz - p.b/2
	 elseif j == 3 then
	    y0 = py + p.a/2
	    z0 = pz + p.b/2
	 else
	    y0 = py - p.a/2
	    z0 = pz + p.b/2
	 end
	 -- Punto del plano en el eje x (antes de la rotación)
--	 pjplano.x0, pjplano.y0, pjplano.z0 = x0, y0, z0
	 x, y, z = M.xyzRotacionSpeed(x0,y0,z0,stheta,ctheta,sphi,cphi)
--	 pjplano.x, pjplano.y, pjplano.z = x, y, z
	 u, v = M.xyz2uvAll(x, y, z, obs)
--	 pjplano.u, pjplano.v = u, v
	 pjplano.x0 = x0
	 pjplano.y0 = y0
	 pjplano.z0 = z0
	 pjplano.x = x
	 pjplano.y = y
	 pjplano.z = z
	 pjplano.u = u
	 pjplano.v = v
	 table.insert(ptosplano, pjplano)
      end
      
      ptosplano.visible = ptos[i].visible
      table.insert(planos, ptosplano)
   end
end


function M.completaPlanosold(obs, ptos, planos)
   local plano
   local theta, phi, stheta, ctheta, sphi, cphi
   local p1x, p1y, p1z
   local p2x, p2y, p2z
   local p3x, p3y, p3z
   local p4x, p4y, p4z
   local pr1x, pr1y, pr1z
   local pr2x, pr2y, pr2z
   local pr3x, pr3y, pr3z
   local pr4x, pr4y, pr4z
   local p1u, p1v, p2u, p2v, p3u, p3v, p4u, p4v

   for i, p in ipairs(ptos) do
      
      plano = {}

      -- Coordenadas x,y,z de puntos del plano en posición theta=90, phi=0
      p1x = 1
      p1y = 0 - p.a/2.0
      p1z = 0 - p.b/2.0
--      plano.p1x = p1x
--      plano.p1y = p1y
--      plano.p1z = p1z
      
      p2x = 1
      p2y = 0 + p.a/2.0
      p2z = 0 - p.b/2.0
--      plano.p2x = p2x
--      plano.p2y = p2y
--      plano.p2z = p2z
      
      p3x = 1
      p3y = 0 - p.a/2.0
      p3z = 0 + p.b/2.0
--      plano.p3x = p3x
--      plano.p3y = p3y
--      plano.p3z = p3z
      
      p4x = 1
      p4y = 0 + p.a/2.0
      p4z = 0 + p.b/2.0
--      plano.p4x = p4x
--      plano.p4y = p4y
--      plano.p4z = p4z

      theta = math.rad(p.thetaD)
      phi = math.rad(p.phiD)
      theta, phi = M.nuevoAnguloGiro(theta, phi)
      stheta = math.sin(theta)
      ctheta = math.cos(theta)
      sphi = math.sin(phi)
      cphi = math.cos(phi)

      pr1x, pr1y, pr1z = M.xyzRotacionSpeed(p1x,p1y,p1z,stheta,ctheta,sphi,cphi)
      pr2x, pr2y, pr2z = M.xyzRotacionSpeed(p2x,p2y,p2z,stheta,ctheta,sphi,cphi)
      pr3x, pr3y, pr3z = M.xyzRotacionSpeed(p3x,p3y,p3z,stheta,ctheta,sphi,cphi)
      pr4x, pr4y, pr4z = M.xyzRotacionSpeed(p4x,p4y,p4z,stheta,ctheta,sphi,cphi)
      
      plano.pr1x = pr1x
      plano.pr1y = pr1y
      plano.pr1z = pr1z
      
      plano.pr2x = pr2x
      plano.pr2y = pr2y
      plano.pr2z = pr2z
      
      plano.pr3x = pr3x
      plano.pr3y = pr3y
      plano.pr3z = pr3z
      
      plano.pr4x = pr4x
      plano.pr4y = pr4y
      plano.pr4z = pr4z

      -- Coordenadas u, v de los puntos de un plano
      plano.p1u, plano.p1v = M.xyz2uvAll(pr1x, pr1y, pr1z, obs)
      plano.p2u, plano.p2v = M.xyz2uvAll(pr2x, pr2y, pr2z, obs)
      plano.p3u, plano.p3v = M.xyz2uvAll(pr3x, pr3y, pr3z, obs)
      plano.p4u, plano.p4v = M.xyz2uvAll(pr4x, pr4y, pr4z, obs)

      plano.visible = ptos[i].visible

      table.insert(planos, plano)
   end
end


function M.xyzRotacion(x, y, z, theta, phi)
   local xprima, yprima, zprima
   local m

   m = x * math.cos(theta) + z * math.sin(theta)

   xprima = m * math.cos(phi) - y * math.sin(phi)
   yprima = m * math.sin(phi) + y * math.cos(phi)
   zprima = -x * math.sin(theta) + z * math.cos(theta)

   return xprima, yprima, zprima
end


function M.xyzRotacionSpeed(x, y, z, sintheta, costheta, sinphi, cosphi)
   local xprima, yprima, zprima
   local m

   m = x * costheta + z * sintheta

   xprima = m * cosphi - y * sinphi
   yprima = m * sinphi + y * cosphi
   zprima = -x * sintheta + z * costheta

   return xprima, yprima, zprima
end


function M.nuevoAnguloGiro(theta, phi)
   return -(math.pi/2 - theta), phi
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
   local u, v
   
   -- Crea tabla con las coordenadas rect y esféricas del punto (grados y rad)
   -- y algunas funciones trigonométricas para ahorrar cálculos.
   PAll = M.SD3dToAll(r, thetaD, phiD)

   -- Crea tabla con las coordenadas esféricas del observador (grados y rad)
   -- y algunas funciones trigonométricas para ahorrar cálculos.   
   viewAll = M.SD3dView(obs)
   
   -- Crea las dos coordenadas del punto en pantalla visto por el observador
   u, v = M.All2uv(PAll, viewAll)

   return u, v
end


-- (02c) **********************************************************************
-- FUNCIÓN AUXILIAR
-- xyz2All(x,y,z)
-- Transforma coord. rectangulares en esféricas y cálculos preparados.
-- Argumentos: coordenadas rectangulares x, y, z.
-- Retorna: Una tabla P con los valores
-- P.x, P.y, P.z, P.r, P.theta, P.phi, P.thetaD, P.phiD,
-- P.sintheta, P.costheta, P.tantheta, P.sinphi, P.cosphi, P.tanphi
function M.xyz2All(x,y,z)
   local P = {}
   P.x = x
   P.y = y
   P.z = z
   
   P.r, P.theta, P.phi = M.xyz2sph(x,y,z)
   
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
   
   x, y, z = M.sphD2xyz(r, thetaD, phiD)

   P.x = x
   P.y = y
   P.z = z
   
   P.r = M.limpia(r)
   P.thetaD = M.limpia(thetaD)
   P.phiD = M.limpia(phiD)

   P.theta = M.limpia(math.rad(thetaD))
   P.phi = M.limpia(math.rad(phiD))

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

--(03b) sphD2xyz -> Transforma coord. esféricas (grados) a rectangulares.	    
-- (03b) **********************************************************************
-- sphD2xyz(r, thetaD, phiD)
-- Transforma coord. esféricas (grados) en rectangulares.
-- Argumentos: coordenadas esféricas r, thetaD y phiD.
-- Retorna: Coordenadas rectangulares
-- OK!
function M.sphD2xyz(r, thetaD, phiD)
   local x, y, z
   local theta, phi

   theta = math.rad(thetaD)
   phi = math.rad(phiD)
   
   x = r * math.sin(theta) * math.cos(phi)
   y = r * math.sin(theta) * math.sin(phi)
   z = r * math.cos(theta)

   x = M.limpia(x)
   y = M.limpia(y)
   z = M.limpia(z)

   return x, y, z
end



---- (02) *********************************************************************
---- FUNCIÓN AUXILIAR
---- (x,y,z) -> TABLA: P.x  P.y  P.z  P.r  P.theta  P.phi
--function M.pointRectStrToRect(strRect)
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
function M.All2uv(P, View)
   local u, v

   u = -P.x * View.sinphi + P.y * View.cosphi
   v = -P.x * View.costhetacosphi - P.y * View.costhetasinphi + P.z * View.sintheta

   return u, v
end


-- (02a) **********************************************************************
-- R3dToSph(x,y,z)
-- Transforma coord. rectangulares en esféricas.
-- Argumentos: coordenadas rectangulares x, y, z.
-- Retorna: Coordenadas esféricas (ángulos en radianes).
function M.xyz2sph(x,y,z)
   local rxy = math.sqrt(x^2 + y^2)
   local r = M.R3dNorm(x,y,z)
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


function M.limpia(valor)
    if math.abs(valor) < 1e-12 then
        return 0.0
    end
    return valor
end
-- ****************************************************************************
-- FUNCIONES DE DEPURACIÓN
-- ****************************************************************************
-- (02a)
-- Código de depuración el LuaLaTeX.
-- Resumen de los datos enviados y procesados por LuaLaTeX.
-- Esfera, Observador y puntos visibles e invisibles.
function M.DEBUGesf(esf)
   -- TABLA ESFERA
   tex.print([[\vspace{1ex}]])
   tex.print([[\noindent\,\textbf{ESFERA}\\]])
   tex.print([[\vspace{1ex}]])
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
   tex.print([[\\]])
   tex.print([[\vspace{1ex}]])
end

function M.DEBUGobs(obs)
   -- TABLA OBSERVADOR
   tex.print([[\vspace{1ex}]])   
   tex.print([[\noindent\,\textbf{OBSERVADOR}\\]])
   tex.print([[\vspace{1ex}]])
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
   tex.print([[\\]])
   tex.print([[\vspace{1ex}]])
end

function M.DEBUGpuntos(ptos)
   -- TABLA PUNTOS
   tex.print([[\vspace{1ex}]])
   tex.print([[\noindent\,\textbf{PUNTOS}\\]])
   tex.print([[\vspace{1ex}]])
   tex.print([[\begin{tabular}{|c|c|c|c|c|}]])
   tex.print([[\hline]])
   tex.print([[ID&$a\times b$&Opac.&Color&Visible\\]])
   tex.print([[\hline]])

   for i, p in ipairs(ptos) do
      tex.print(string.format(
		   [[%d&%.2f\times%.2f&%.2f&%s&%s\\]],
   	  i,p.a, p.b, p.opacidad, p.color, p.visible))
   end
   tex.print([[\hline]])
   tex.print([[\end{tabular}]])
   tex.print([[\\]])
   tex.print([[\vspace{1ex}]])
end

function M.DEBUGcoordpuntos(ptos)
   -- TABLA COORDENADAS DE PUNTOS
   tex.print([[\vspace{1ex}]])
   tex.print([[\noindent\,\textbf{COORDENADAS DE PUNTOS}\\]])
   tex.print([[\vspace{1ex}]])
   tex.print([[\begin{tabular}{|c|c|c|c|c|}]])
   tex.print([[\hline]])
   tex.print([[ID&$(r,\theta,\phi)$&$(x,y,z)$&$(u,v)$&Visible\\]])
   tex.print([[\hline]])

   for i, p in ipairs(ptos) do
      tex.print(string.format(
[[%d&(%.2f,\qty{%.2f}{\degree},\qty{%.2f}{\degree})&(%.2f,%.2f,%.2f)&(%.2f,%.2f)&%s\\]],  i, p.r, p.thetaD, p.phiD,p.x, p.y, p.z, p.u, p.v, p.visible))
   end
   tex.print([[\hline]])
   tex.print([[\end{tabular}]])
   tex.print([[\\]])
   tex.print([[\vspace{1ex}]])
end

function M.DEBUGplanosobs(planos)
   -- TABLA PLANOS
   tex.print([[\vspace{1ex}]])
   tex.print([[\noindent\,\textbf{PLANOS SEGÚN OBSERVADOR}\\]])
   tex.print([[\vspace{1ex}]])
   tex.print([[\begin{tabular}{|c|c|c|c|c|c|}]])
   tex.print([[\hline]])
   tex.print([[Plano & p1 & p2 & p3 & p4 & Visible\\]])
   tex.print([[\hline]])

   for i, p in ipairs(planos) do
      tex.print(string.format(
   [[%d & (%.3f,%.3f) & (%.3f,%.3f) & (%.3f,%.3f) & (%.3f,%.3f) & %s\\]],
      i, p[1].u, p[1].v, p[2].u, p[2].v, p[3].u, p[3].v, p[4].u, p[4].v, p.visible))
   end
   tex.print([[\hline]])
   tex.print([[\end{tabular}]])
   tex.print([[\\]])
   tex.print([[\vspace{1ex}]])
end

-- ----------------------------------------------------------------------------


return M



