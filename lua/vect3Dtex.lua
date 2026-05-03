-- vect3Dtex.lua

-- (00a) **********************************************************************
-- FUNCIÓN DE USUARIO
-- proy_PRect(strRect, thetaDeg, phiDeg)
-- Escribe una cadena con las coordenadas u, v del punto en la pantalla.
-- Argumentos:
--     Cadena con las coordenadas rectangulares del punto: "(x,y,z)"
--     Ángulo theta de la vista o perspectiva: thetav
--     Àngulo phi de la vista o perspectiva: phiv
-- Retorna:
--     Cadena con las coordenadas (u,v) de la pantalla: "(u,v)"
function TEXproy_PRect(x, y, z, thetaDeg, phiDeg)
   local P = {}
   local View = {}
   local Proy = {}
   
   P = R3dToAll(x,y,z)

   View = SD3dView(thetaDeg, phiDeg)

   u, v = proyPoint(P, View)

   tex.sprint(string.format("%.4f, %.4f", u, v))
end

-- (00b) **********************************************************************
-- FUNCIÓN DE USUARIO
-- proy_PSph(strRect, thetaDeg, phiDeg)
-- Escribe una cadena con las coordenadas u, v del punto en la pantalla.
-- Argumentos:
--     Cadena con las coordenadas rectangulares del punto: "(x,y,z)"
--     Ángulo theta de la vista o perspectiva: thetav
--     Àngulo phi de la vista o perspectiva: phiv
-- Retorna:
--     Cadena con las coordenadas (u,v) de la pantalla: "(u,v)"
function TEXproy_PSph(r, PthetaDeg, PphiDeg, thetaDeg, phiDeg)
   local P = {}
   local View = {}
   local Proy = {}
   
   P = SD3dToAll(r, PthetaDeg, PphiDeg)

   View = SD3dView(thetaDeg, phiDeg)

   u, v = proyPoint(P, View)

   tex.sprint(string.format("%.4f, %.4f", u, v))
end


--(03b) SD3dToRect -> Transforma coord. esféricas (grados) a rectangulares.	    
-- (03b) **********************************************************************
-- SD3dToRect(r, thetaDeg, phiD)
-- Transforma coord. esféricas (grados) en rectangulares.
-- Argumentos: coordenadas esféricas r, thetaDeg y phiDeg.
-- Retorna: Coordenadas rectangulares
function SD3dToRect(r,thetaDeg,phiDeg)
   local x, y, z
   local theta, phi

   theta = math.rad(thetaDeg)
   phi = math.rad(phiDeg)
   
   x = r * math.sin(theta) * math.cos(phi)
   y = r * math.sin(theta) * math.sin(phi)
   z = r * math.cos(theta)

   return x, y, z
end




---- FUNCIONES AUXILIARES *******************************************************
---- (03) *********************************************************************
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


-- (02c) **********************************************************************
-- FUNCIÓN AUXILIAR
-- R3dToAll(x,y,z)
-- Transforma coord. rectangulares en esféricas y cálculos preparados.
-- Argumentos: coordenadas rectangulares x, y, z.
-- Retorna: Una tabla P con los valores
-- P.x, P.y, P.z, P.r, P.theta, P.phi, P.thetaDeg, P.phiDeg,
-- P.sintheta, P.costheta, P.tantheta, P.sinphi, P.cosphi, P.tanphi
function R3dToAll(x,y,z)
   local P = {}
   P.x = x
   P.y = y
   P.z = z
   
   P.r, P.theta, P.phi = R3dToSph(x,y,z)
   
   P.thetaDeg = math.deg(P.theta)
   P.phiDeg = math.deg(P.phi)

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
-- SD3dToAll(r,thetaDeg,phiDeg)
-- Transforma coord. esféricas (grados) en rectangulares y cálculos trigonom.
-- Argumentos: coordenadas esféricas (grados) r, thetaDeg y phiDeg
-- Retorna: Una tabla P con los valores
-- P.x, P.y, P.z, P.r, P.theta, P.phi, P.thetaDeg, P.phiDeg,
-- P.sintheta, P.costheta, P.tantheta, P.sinphi, P.cosphi, P.tanphi
function SD3dToAll(r,thetaDeg,phiDeg)
   local P = {}
   P.r = r
   P.thetaDeg = thetaDeg
   P.phiDeg = phiDeg
   
   P.x, P.y, P.z = SD3dToRect(r,thetaDeg,phiDeg)
   
   P.theta = math.rad(P.thetaDeg)
   P.phi = math.rad(P.phiDeg)

   P.sintheta = math.sin(P.theta)
   P.costheta = math.cos(P.theta)
   P.tantheta = math.tan(P.theta)
   P.sinphi = math.sin(P.phi)
   P.cosphi = math.cos(P.phi)
   P.tanphi = math.tan(P.phi)

   return P
end


-- (06a) **********************************************************************
-- FUNCIÓN AUXILIAR
-- SD3dView(theta, phi)
-- Define vista en perspectiva mediante ángulos (r=1)
-- Argumentos: Ángulos theta y phi en grados de la vista.
-- Retorna: Una tabla View con los valores de los ángulos y func. trig.
-- View.theta, View.phi, View.thetaDeg, View.phiDeg
-- View.sintheta, View.costheta, View.tantheta,
-- View.sinphi, View.cosphi, View.tanphi
function SD3dView(thetaDeg, phiDeg)
   local View = {}
   View.thetaDeg = thetaDeg
   View.phiDeg= phiDeg
   View.theta = math.rad(thetaDeg)
   View.phi = math.rad(phiDeg)
   View.sintheta = math.sin(View.theta)
   View.costheta = math.cos(View.theta)
   View.tantheta = math.tan(View.theta)
   View.sinphi = math.sin(View.phi)
   View.cosphi = math.cos(View.phi)
   View.tanphi = math.tan(View.phi)
   View.costhetacosphi = math.cos(View.theta) * math.cos(View.phi)
   View.costhetasinphi = math.cos(View.theta) * math.sin(View.phi)

   return View
end


-- (06a) **********************************************************************
-- FUNCIÓN AUXILIAR
-- proyPoint(P, View)
-- Proyecta punto P en la pantalla según la perspectiva/vista View.
-- Argumentos: Tabla completa con punto P y tabla completa con vista View
-- Retorna: Tabla con las coordenadas (u,v) del punto proyectado en la pantalla
-- PointProy.u, PointProy.v
function proyPoint(P, View)
   local u, v
   --local PointProy = {}

   --PointProy.x = P.x
   --PointProy.y = P.y
   --PointProy.z = P.z
   --PointProy.r = P.r
   --PointProy.theta = P.theta
   --PointProy.phi = P.phi
   --PointProy.thetaDeg = P.thetaDeg
   --PointProy.phiDeg = P.phiDeg

   u = -P.x * View.sinphi + P.y * View.cosphi
   v = -P.x * View.costhetacosphi - P.y * View.costhetasinphi + P.z * View.sintheta

   return u, v
end


-- (02a) **********************************************************************
-- R3dToSph(x,y,z)
-- Transforma coord. rectangulares en esféricas.
-- Argumentos: coordenadas rectangulares x, y, z.
-- Retorna: Coordenadas esféricas (ángulos en radianes).
function R3dToSph(x,y,z)
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
function R3dNorm(x,y,z)
   
   return math.sqrt(x^2 + y^2 + z^2)
end
