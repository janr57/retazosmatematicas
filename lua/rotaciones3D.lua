-- rot3D.lua
-- Cálculos numéricos en 3D
-- El fichero rot3Dtex.lua debe utilizarlo

-- (03) *******************************************************************
-- (x,y,z) -> TABLA: P.x  P.y  P.z  P.r  P.theta  P.phi
-- Descripción:
-- A esta función se le pasan tres coordenadas cartesianas rectangulares x,y,z
-- Retorna una tabla P, que contiene los valores P.x, P.y, P.z, además de las
-- coordenadas esféricas P.r, P.theta, P.phi.
function rect3DToSph(vector3D)
local P = {}
local found, last, i
local rxy, cosphi, tanphi, sintheta

-- PONER COORDENADAS CARTESIANAS EN LA TABLA P
-- P.x
-- P.y
-- P.z
--
-- Buscamos "("
found, last = vector3D:find("%(")
if not found then
   return nil
end
-- Buscamos "," para localizar la coordenada x
i = last + 1
found, last = vector3D:find(",", i)
if found then
   P.x = tonumber(vector3D:sub(i, last-1))
else
   return nil
end
-- Buscamos la segunda "," para localizar la coordenada y
i = last + 1
found, last = vector3D:find(",", i)
if found then
   P.y = tonumber(vector3D:sub(i, last-1))
else
   return nil
end
-- Buscamos ")" para localizar la coordenada z
i = last + 1
found, last = vector3D:find("%)", i)
if found then
   P.z = tonumber(vector3D:sub(i, last-1))
else
   return nil
end

-- COORDENADAS ESFÉRICAS EN LA TABLA P
-- P.r
-- P.theta
-- P.phi
--
P = completeSphericalCoordsTable(P)

return P
end
-- **************************************************************************



-- Función auxiliar
-- (04) *********************************************************************
-- r, theta, phi -> TABLA: P.x  P.y  P.z  P.r  P.theta  P.phi
--
function point3DToTableSph(r,theta,phi)
local P = {}

-- Integramos las coordenadas cartesianas en la tabla
P.r = tonumber(r)
P.theta = tonumber(theta)
P.phi = tonumber(phi)

-- Coordenadas rectangulares
P.x = P.r * math.cos(math.rad(P.phi)) * math.sin(math.rad(P.theta))
P.y = P.r * math.sin(math.rad(P.phi)) * math.sin(math.rad(P.theta))
P.z = P.r * math.cos(math.rad(P.theta))

--[[DEBUG:
   print("P.r = " .. P.r)
   print("P.theta = " .. P.theta)
   print("P.phi = " .. P.phi)
   print("P.x = " .. P.x)
   print("P.y = " .. P.y)
   print("P.z = " .. P.z)
   print()
--]]

   
if math.abs(P.x) < 1e-15 then
   P.x = 0
end
if math.abs(P.y) < 1e-15 then
   P.y = 0
end
if math.abs(P.z) < 1e-15 then
   P.z = 0
end

--[[DEBUG:
   print("P.r = " .. P.r)
   print("P.theta = " .. P.theta)
   print("P.phi = " .. P.phi)
   print("P.x = " .. P.x)
   print("P.y = " .. P.y)
   print("P.z = " .. P.z)
   print()
--]]



return P
end
-- **************************************************************************



-- Función auxiliar
-- (03) *********************************************************************
-- (x,y,z) -> TABLA: P.x  P.y  P.z  P.r  P.theta  P.phi
function vector2DToTable(vector2D)
local P = {}
local found, last, i
local rxy, cosphi, tanphi, sintheta

-- PONER COORDENADAS CARTESIANAS EN LA TABLA P
-- P.x
-- P.y
--
-- Buscamos "("
found, last = vector2D:find("%(")
if not found then
   return nil
end
-- Buscamos "," para localizar la coordenada x
i = last + 1
found, last = vector2D:find(",", i)
if found then
   P.x = tonumber(vector2D:sub(i, last-1))
else
   return nil
end
-- Buscamos ")" para localizar la coordenada y
i = last + 1
found, last = vector2D:find("%)", i)
if found then
   P.y = tonumber(vector2D:sub(i, last-1))
else
   return nil
end

-- COORDENADAS POLARES EN LA TABLA P
-- P.r
-- P.phi
--
P = completePolarCoordsTable(P)

return P
end
-- **************************************************************************



-- Función auxiliar
-- (05) *********************************************************************
-- TABLA P que contiene P.x P.y P.z -> Se completa con P.r P.theta y P.phi
function completeSphericalCoordsTable(P)
   local Q
   local rxy, cosphi, tanphi, sintheta

   Q = {}
   Q.x = P.x
   Q.y = P.y
   Q.z = P.z
   
   rxy = math.sqrt(Q.x^2 + Q.y^2)
   cosphi = Q.x/rxy
   tanphi = Q.y/Q.x
   -- Ángulo phi
   Q.phi = math.deg(math.atan(tanphi))
   -- Ahora corrijo si no es así
   if cosphi < 0 then
      Q.phi = Q.phi + 180
   end
   -- Módulo r
   Q.r = math.sqrt(Q.x^2 + Q.y^2 + Q.z^2)
   -- Ángulo theta
   sintheta = rxy/Q.r
   Q.theta = math.deg(math.asin(sintheta))
   if Q.theta < 0 then
      Q.theta = 180 - Q.theta
   end
   -- Si el ángulo phi no está definido 'nan'
   -- es porque el ángulo theta es 0,
   -- entonces phi=0, por ejemplo
   if Q.phi ~= Q.phi and Q.theta == 0 then
      Q.phi = 0
   end

   return Q
end

-- **************************************************************************


-- Función auxiliar
-- (05) *********************************************************************
-- TABLA P que contiene P.x P.y P.z -> Se completa con P.r P.theta y P.phi
function completePolarCoordsTable(P)
   local Q
   local rxy, cosphi, tanphi

   Q = {}
   Q.x = P.x
   Q.y = P.y

   -- Módulo r
   Q.r = math.sqrt(Q.x^2 + Q.y^2)
   -- Ángulo phi
   cosphi = Q.x/Q.r
   tanphi = Q.y/Q.x
   Q.phi = math.deg(math.atan(tanphi))
   -- Ahora corrijo si no es así
   if cosphi < 0 then
      Q.phi = Q.phi + 180
   end

   return Q
end

-- **************************************************************************


-- Función auxiliar
-- (06) *********************************************************************
function calcSphereTangPlanePoints(P, V1, V2, s1, s2)
   local PT1, PT2, PT3, PT4
   local xval, yval, zval
   local sintheta, costheta, sinphi, cosphi
   
   -- Los cuatro puntos del plano tangente
   PT1 = {}; PT2 = {}; PT3 = {}; PT4 = {}

   -- PLANO TANGENTE ORIGINAL
   -- 1) Primero se calculan los puntos del plano tangente
   --    en el punto (0,0,1):
   --
   -- Primer punto tangente
   xval = 0 + s1 * V1.x + s2 * V2.x
   yval = 0 + s1 * V1.y + s2 * V2.y
   zval = 1 + s1 * V1.z + s2 * V2.z
   PT1 = {x=xval, y=yval, z=zval}
   
   -- Segundo punto tangente
   xval = 0 + s1 * V1.x - s2 * V2.x
   yval = 0 + s1 * V1.y - s2 * V2.y
   zval = 1 + s1 * V1.z - s2 * V2.z
   PT2 = {x=xval, y=yval, z=zval}
   -- Tercer punto tangente
   xval = 0 - s1 * V1.x - s2 * V2.x
   yval = 0 - s1 * V1.y - s2 * V2.y
   zval = 1 - s1 * V1.z - s2 * V2.z
   PT3 = {x=xval, y=yval, z=zval}
   -- Cuarto punto tangente
   xval = 0 - s1 * V1.x + s2 * V2.x
   yval = 0 - s1 * V1.y + s2 * V2.y
   zval = 1 - s1 * V1.z + s2 * V2.z
   PT4 = {x=xval, y=yval, z=zval}

   PT1 = completeSphericalCoordsTable(PT1)
   PT2 = completeSphericalCoordsTable(PT2)
   PT3 = completeSphericalCoordsTable(PT3)
   PT4 = completeSphericalCoordsTable(PT4)

   --[[DEBUG:
   print("--------------------------------------------------------")
   print("Función 'calcSphereTangPlanePoints(P, V1, V2, s1, s2)'")
   print("Antes de rotar los PT1, PT2, PT3 y PT4")
   print("PT1.x = " .. PT1.x)
   print("PT1.y = " .. PT1.y)
   print("PT1.z = " .. PT1.z)
   print("PT1.r = " .. PT1.r)
   print("PT1.theta = " .. PT1.theta)
   print("PT1.phi = " .. PT1.phi)
   print()
   print("PT2.x = " .. PT2.x)
   print("PT2.y = " .. PT2.y)
   print("PT2.z = " .. PT2.z)
   print("PT2.r = " .. PT2.r)
   print("PT2.theta = " .. PT2.theta)
   print("PT2.phi = " .. PT2.phi)
   print()
   print("PT3.x = " .. PT3.x)
   print("PT3.y = " .. PT3.y)
   print("PT3.z = " .. PT3.z)
   print("PT3.r = " .. PT3.r)
   print("PT3.theta = " .. PT3.theta)
   print("PT3.phi = " .. PT3.phi)
   print()
   print("PT4.x = " .. PT4.x)
   print("PT4.y = " .. PT4.y)
   print("PT4.z = " .. PT4.z)
   print("PT4.r = " .. PT4.r)
   print("PT4.theta = " .. PT4.theta)
   print("PT4.phi = " .. PT4.phi)
   print()
   --]]

   -- PLANO TANGENTE ROTADO
   -- 2) Después se rotan los cuatro puntos de acuerdo con las coordenadas
   -- esféricas del punto de tangencia P:
   -- Dos giros:
   --    Primero - giro de 90-theta alrededor del eje x
   --    Segundo - giro de -(90-phi) alrededor del eje z
   
   sintheta = math.sin(math.rad(P.theta))
   sintheta = sintheta - sintheta % 1e-15
   costheta = math.cos(math.rad(P.theta))
   costheta = costheta - costheta % 1e-15
   
   sinphi = math.sin(math.rad(P.phi))
   sinphi = sinphi - sinphi % 1e-15
   cosphi = math.cos(math.rad(P.phi))
   cosphi = cosphi - cosphi % 1e-15

   --[[DEBUG:   
   print()
   print("***********")
   print("theta = " .. P.theta)
   print("sin(theta) = " .. sintheta)
   print("cos(theta) = " .. cosphi)
   print()
   print("phi = " .. P.phi)
   print("sin(phi) = " .. sinphi)
   print("cos(phi) = " .. cosphi)
   print("***********")
   print()
   --]]
   
   -- PT1
   xval = PT1.x * cosphi * costheta
   xval = xval - PT1.y * sinphi
   xval = xval + PT1.z * cosphi * sintheta
   --
   yval = PT1.x * sinphi * costheta
   yval = yval + PT1.y * cosphi
   yval = yval + PT1.z * sinphi * sintheta
   --
   zval = -PT1.x * sintheta + PT1.z * costheta
   --
   PT1.x = xval
   PT1.y = yval
   PT1.z = zval   

   -- PT2
   xval = PT2.x * cosphi * costheta
   xval = xval - PT2.y * sinphi
   xval = xval + PT2.z * cosphi * sintheta
   --
   yval = PT2.x * sinphi * costheta
   yval = yval + PT2.y * cosphi
   yval = yval + PT2.z * sinphi * sintheta
   --
   zval = -PT2.x * sintheta + PT2.z * costheta
   --
   PT2.x = xval
   PT2.y = yval
   PT2.z = zval   

   -- PT3
   xval = PT3.x * cosphi * costheta
   xval = xval - PT3.y * sinphi
   xval = xval + PT3.z * cosphi * sintheta
   --
   yval = PT3.x * sinphi * costheta
   yval = yval + PT3.y * cosphi
   yval = yval + PT3.z * sinphi * sintheta
   --
   zval = -PT3.x * sintheta + PT3.z * costheta
   --
   PT3.x = xval
   PT3.y = yval
   PT3.z = zval   

   -- PT4
   xval = PT4.x * cosphi * costheta
   xval = xval - PT4.y * sinphi
   xval = xval + PT4.z * cosphi * sintheta
   --
   yval = PT4.x * sinphi * costheta
   yval = yval + PT4.y * cosphi
   yval = yval + PT4.z * sinphi * sintheta
   --
   zval = -PT4.x * sintheta + PT4.z * costheta
   --
   PT4.x = xval
   PT4.y = yval
   PT4.z = zval   

   --[[DEBUG:
   print("Después de rotar los PT1, PT2, PT3 y PT4")
   print("PT1.x = " .. PT1.x)
   print("PT1.y = " .. PT1.y)
   print("PT1.z = " .. PT1.z)
   print()
   print("PT2.x = " .. PT2.x)
   print("PT2.y = " .. PT2.y)
   print("PT2.z = " .. PT2.z)
   print()
   print("PT3.x = " .. PT3.x)
   print("PT3.y = " .. PT3.y)
   print("PT3.z = " .. PT3.z)
   print()
   print("PT4.x = " .. PT4.x)
   print("PT4.y = " .. PT4.y)
   print("PT4.z = " .. PT4.z)
   print()
   --]]
   
   return PT1, PT2, PT3, PT4
end
-- **************************************************************************



-- Función auxiliar
-- (07) *********************************************************************
-- IMPRIME EL 'PATH' PARA TIKZ DEL PLANO TANGENTE
-- Parámetros
-- 'PT1', 'PT2', 'PT3' y 'PT4' son los cuatro puntos que definen el
--                             plano tangente que hay que escribir.
function pathTanPlane(PT1, PT2, PT3, PT4)
   local str1, str2, str3, str4

   str1 = "(" .. PT1.x .. "," .. PT1.y .. "," .. PT1.z .. ")" 
   str2 = "(" .. PT2.x .. "," .. PT2.y .. "," .. PT2.z .. ")"
   str3 = "(" .. PT3.x .. "," .. PT3.y .. "," .. PT3.z .. ")"
   str4 = "(" .. PT4.x .. "," .. PT4.y .. "," .. PT4.z .. ")"

   --[[DEBUG:
   print("-------------------------------------------")
   print("Función 'pathTangPlane(TP1, TP2, TP3, TP4)'")
   print("str1 = " .. str1)
   print("str2 = " .. str2)
   print("str3 = " .. str3)
   print("str4 = " .. str4)
   print()
   --]]
   
   return str1 .." -- ".. str2 .." -- ".. str3 .." -- ".. str4
end
-- **************************************************************************


-- Función auxiliar
-- (08) *********************************************************************
-- IMPRIME EL 'PATH' PARA TIKZ DEL PLANO TANGENTE
-- Parámetros
-- 'PT1', 'PT2', 'PT3' y 'PT4' son los cuatro puntos que definen el
--                             plano tangente que hay que escribir.
function pathVector(P, E)
   local strP, strE

   strP = "(" .. P.x .. "," .. P.y .. "," .. P.z .. ")"
   strE = "(" .. E.x .. "," .. E.y .. "," .. E.z .. ")"

   --[[DEBUG:
   print()
   print("-------------------------------------------")
   print("Función 'pathVector(P, E)'")
   print("strP = " .. strP)
   print("strE = " .. strE)
   print()
   --]]
   
   return strP .." -- ".. strE
end
-- **************************************************************************

-- Función auxiliar
-- (08) *********************************************************************
-- IMPRIME EL 'PATH' PARA TIKZ DEL PUNTO
-- Parámetros
-- 'P': El punto
function pathPoint(P)
   local strP

   strP = "(" .. P.x .. "," .. P.y .. "," .. P.z .. ")"

   --[[DEBUG:
   print()
   print("-------------------------------------------")
   print("Función 'pathPunto(P)'")
   print("strP = " .. strP)
   print()
   --]]
   
   return strP
end
-- **************************************************************************




-- Funciones útiles para trabajar en 3D con 'lualatex'
function spherical2x(r,theta,phi)
   return r*math.sin(theta*math.pi/180)*math.cos(phi*math.pi/180)
end

function spherical2y(r,theta,phi)
   return r*math.sin(theta*math.pi/180)*math.sin(phi*math.pi/180)
end

function spherical2z(r,theta,phi)
   return r*math.cos(theta*math.pi/180)
end

function getxRot(alpha,nx,ny,nz,x,y,z)
   rad = math.rad(alpha)
   local xfactor = (1-math.cos(rad))*nx^2+math.cos(rad)
   local yfactor = (1-math.cos(rad))*nx*ny-nz*math.sin(rad)
   local zfactor = (1-math.cos(rad))*nx*nz+ny*math.sin(rad)
   return xfactor*x + yfactor*y + zfactor*z
end

function getyRot(alpha,nx,ny,nz,x,y,z)
   rad = math.rad(alpha)
   local xfactor = (1-math.cos(rad))*ny*nx+nz*math.sin(rad)
   local yfactor = (1-math.cos(rad))*ny^2+math.cos(rad)
   local zfactor = (1-math.cos(rad))*ny*nz-nx*math.sin(rad)
   return xfactor*x + yfactor*y + zfactor*z
end

function getzRot(alpha,nx,ny,nz,x,y,z)
   rad = math.rad(alpha)
   local xfactor = (1-math.cos(rad))*nz*nx-ny*math.sin(rad)
   local yfactor = (1-math.cos(rad))*nz*ny+nx*math.sin(rad)
   local zfactor = (1-math.cos(rad))*nz^2+math.cos(rad)
   return xfactor*x + yfactor*y + zfactor*z
end

