-- vect3D.lua
--[[
Cálculos numéricos relacionados con vectores 3D en distintos sistemas de
coordenadas, considerando también sus transformaciones, como desplazamientos,
rotaciones, etc., y sus proyecciones en un plano, esto último para facilitar
su representación en la pantalla de un ordenador.
]]

--[[ RELACIÓN DE FUNCIONES
   (00a) strR3dToRect: "(x,y,z)" -> x, y, z 
   -----
   (01a) R3dNorm: x, y, z -> Norma (o módulo)
   (01b) R3dToSph -> x,y,z -> r, theta, phi (ángulos en radianes)
   (01c) R3dToAll: x,y,z -> Tabla P con coord. rect., esfér. y cálc. trigonom.
   -----
   -----
   (03a) SD3dView: theta,phi -> Tabla View con punto de vista y cálc. trigonom.
   -----
   -- proyPoint: Tablas P, View -> (u,v) Coordenadas proyectadas
]]

-- FUNCIONES AUXILIARES *******************************************************
-- (00a) *********************************************************************
-- FUNCIÓN AUXILIAR
-- Transforma una cadena "(x,y,z)" en las coordenadas x,y,z separadas.
-- Argumentos: Cadena numérica "(x,y,z)".
-- Retorna: Valores numéricos separados x, y, z.
-- Resumen: "(x,y,z)" -> x, y, z
function strR3DToRect(strRect)
   local x, y, z
   local found, last, i

-- Buscamos "("
found, last = strRect:find("%(")
if not found then
   return nil
end
-- Buscamos "," para localizar la coordenada x
i = last + 1
found, last = strRect:find(",", i)
if found then
   x = tonumber(strRect:sub(i, last-1))
else
   return nil
end
-- Buscamos la segunda "," para localizar la coordenada y
i = last + 1
found, last = strRect:find(",", i)
if found then
   y = tonumber(strRect:sub(i, last-1))
else
   return nil
end
-- Buscamos ")" para localizar la coordenada z
i = last + 1
found, last = strRect:find("%)", i)
if found then
   z = tonumber(strRect:sub(i, last-1))
else
   return nil
end

return x, y, z
end

-- (01a) **********************************************************************
-- FUNCIÓN AUXILIAR
-- R3dNorm(x,y,z)
-- Calcula el módulo de un vector expresado en coordenadas rectangulares.
-- Argumentos: coordenadas rectangulares x, y, z.
-- Retorna: Módulo del vector.
-- Resumen: x,y,z -> módulo o norma
function R3dNorm(x,y,z)
   return math.sqrt(x^2 + y^2 + z^2)
end


-- (01b) **********************************************************************
-- R3dToSph(x,y,z)
-- Transforma coord. rectangulares en esféricas.
-- Argumentos: coordenadas rectangulares x, y, z.
-- Retorna: Coordenadas esféricas (ángulos en radianes).
-- Resumen: x,y,z -> r, theta, phi (ángulos en radianes).
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


-- (01c) **********************************************************************
-- FUNCIÓN AUXILIAR
-- R3dToAll(x,y,z)
-- Crea tabla con coord. rectangulares, esféricas y cálculos trigonométricos.
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
-- Retorna: u, v  coordenadas del punto proyectado en la pantalla
-- PointProy.u, PointProy.v
-- Resumen: Tablas P, View -> u, v
function proyPoint(P, View)
   local u, v

   u = -P.x * View.sinphi + P.y * View.cosphi
   v = -P.x * View.costhetacosphi - P.y * View.costhetasinphi + P.z * View.sintheta

   return u, v
end








--(01a) R3DNormalizeVector -> Normaliza un vetor expr. en coord. rect.
-- Resumen: x,y,z -> ux,uy,uz
--function R3DNormalizeVector(x,y,z)
--   local mod = R3DMod(x,y,z)
--   return x/mod, y/mod, z/mod
--end


--(02b) R3dToSphDeg -> Transforma coord. rect. en esféricas (grados)
---- (02b) **********************************************************************
---- R3dToSphDeg(x,y,z)
---- Transforma coord. rectangulares en esféricas.
---- Argumentos: coordenadas rectangulares x, y, z.
---- Retorna: Coordenadas esféricas (ángulos en grados sexagesimales).
--function R3dToSphDeg(x,y,z)
--   local r, theta, phi
--   r, theta, phi = R3dToSph(x,y,z)
--   theta = math.deg(theta)
--   phi = math.deg(phi)
--   return r, theta, phi
--end



--(03a) S3dToRect -> Transforma coord. esféricas (rad) a rectangulares.
---- (03a) **********************************************************************
---- S3dToRect(r,theta,phi)
---- Transforma coord. esféricas (radianes) en rectangulares.
---- Argumentos: coordenadas esféricas r, theta y phi.
---- Retorna: Coordenadas rectangulares
--function S3dToRect(r,theta,phi)
--   local x, y, z
--   
--   x = r * math.sin(theta) * math.cos(phi)
--   y = r * math.sin(theta) * math.sin(phi)
--   z = r * math.cos(theta)
--
--   return x, y, z
--end


--(03b) SD3dToRect -> Transforma coord. esféricas (grados) a rectangulares.	    
---- (03b) **********************************************************************
---- SD3dToRect(r, thetaDeg, phiD)
---- Transforma coord. esféricas (grados) en rectangulares.
---- Argumentos: coordenadas esféricas r, thetaDeg y phiDeg.
---- Retorna: Coordenadas rectangulares
--function SD3dToRect(r,theta,phi)
--   local x, y, z
--   local theta, phi
--
--   theta = math.rad(thetaDeg)
--   phi = math.rad(phiDeg)
--   
--   x = r * math.sin(theta) * math.cos(phi)
--   y = r * math.sin(theta) * math.sin(phi)
--   z = r * math.cos(theta)
--
--   return x, y, z
--end


--(03c) S3dToRectAll -> Transforma coord. esféricas (rad) en rectangulares
--      con tablas que contienen algunos cálculos trigonométricos.	    
---- (03c) **********************************************************************
---- S3dToAll(r,theta,phi)
---- Transforma coord. esféricas (radianes) en rectangulares y cálculos preparados.
---- Argumentos: coordenadas esféricas (radianes) r, theta y phi
---- Retorna: Una tabla P con los valores
---- P.x, P.y, P.z, P.r, P.theta, P.phi, P.thetaDeg, P.phiDeg,
---- P.sintheta, P.costheta, P.tantheta, P.sinphi, P.cosphi, P.tanphi
--function S3dToRectAll(r,theta,phi)
--   local P = {}
--   P.r = r
--   P.theta = theta
--   P.phi = phi
--   
--   P.x, P.y, P.z = S3dToRect(r,theta,phi)
--   
--   P.thetaDeg = math.deg(P.theta)
--   P.phiDeg = math.deg(P.phi)
--
--   P.sintheta = math.sin(P.theta)
--   P.costheta = math.cos(P.theta)
--   P.tantheta = math.tan(P.theta)
--   P.sinphi = math.sin(P.phi)
--   P.cosphi = math.cos(P.phi)
--   P.tanphi = math.tan(P.phi)
--
--   return P
--end
--

--(03d) SD3dToAll -> Transforma coord. esféricas (grados) en rectangulares
--      con tablas que contienen algunos cálculos trigonométricos.
---- (03d) **********************************************************************
---- SD3dToAll(r,thetaDeg,phiDeg)
---- Transforma coord. esféricas (grados) en rectangulares y cálculos trigonom.
---- Argumentos: coordenadas esféricas (grados) r, thetaDeg y phiDeg
---- Retorna: Una tabla P con los valores
---- P.x, P.y, P.z, P.r, P.theta, P.phi, P.thetaDeg, P.phiDeg,
---- P.sintheta, P.costheta, P.tantheta, P.sinphi, P.cosphi, P.tanphi
--function SD3dToRectAll(r,thetaDeg,phiDeg)
--   local P = {}
--   P.r = r
--   P.thetaDeg = thetaDeg
--   P.phiDeg = phiDeg
--   
--   P.x, P.y, P.z = SD3dToRect(r,thetaDeg,phiDeg)
--   
--   P.theta = math.deg(P.thetaDeg)
--   P.phi = math.deg(P.phiDeg)
--
--   P.sintheta = math.sin(P.theta)
--   P.costheta = math.cos(P.theta)
--   P.tantheta = math.tan(P.theta)
--   P.sinphi = math.sin(P.phi)
--   P.cosphi = math.cos(P.phi)
--   P.tanphi = math.tan(P.phi)
--
--   return P
--end
--
--
--
---- (03) *********************************************************************
---- FUNCIÓN AUXILIAR
---- (x,y,z) -> TABLA: P.x  P.y  P.z  P.r  P.theta  P.phi
--function point3ToTable(vector3D)
--local P = {}
--local found, last, i
--local rxy, cosphi, tanphi, sintheta
--
---- PONER COORDENADAS CARTESIANAS EN LA TABLA P A PARTIR DE "(x,y,z)"
---- P.x
---- P.y
---- P.z
----
---- Buscamos "("
--found, last = vector3D:find("%(")
--if not found then
--   return nil
--end
---- Buscamos "," para localizar la coordenada x
--i = last + 1
--found, last = vector3D:find(",", i)
--if found then
--   P.x = tonumber(vector3D:sub(i, last-1))
--else
--   return nil
--end
---- Buscamos la segunda "," para localizar la coordenada y
--i = last + 1
--found, last = vector3D:find(",", i)
--if found then
--   P.y = tonumber(vector3D:sub(i, last-1))
--else
--   return nil
--end
---- Buscamos ")" para localizar la coordenada z
--i = last + 1
--found, last = vector3D:find("%)", i)
--if found then
--   P.z = tonumber(vector3D:sub(i, last-1))
--else
--   return nil
--end
--
---- COORDENADAS ESFÉRICAS EN LA TABLA P
---- P.r
---- P.theta
---- P.phi
----
--P = completeSphericalCoordsTable(P)
--P = R3dToAll(P.x, P.y, P.z)
--
--return P
--end
--
--
