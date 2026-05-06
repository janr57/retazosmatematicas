-- rotaciones3D.lua

-- FUNCIONES DE USUARIO
-- (01a) function sphereTanPlane(vector, alpha, s1, s2)
-- (01b) function sphereTanPlaneSph(r, theta, phi, alpha, s1, s2)

-- (02a) function vectorAtPoint(p, v, s)
-- (02b) function vectorAtPointSph(r, theta, phi, v, s)
-- (03a) function sphereNormalVectorAtPoint(p, s)
-- (03b) function sphereNormalVectorAtPointSph(r, theta, phi, s)

-- (04a) function sphereVectorAtTanPlane(p, v, alpha, s)
-- (04b) function sphereVectorAtTanPlaneSph(r, theta, phi, v, alpha, s)

-- (05a) function point(p)
-- (05b) function pointSph(r, theta, phi)

-- (06a) function radialVectorAtPointSph(r, theta, phi, s)

-- ****************************************************************************
-- FUNCIÓN DE USUARIO
-- (01a) **********************************************************************
-- PLANO TANGENTE EN EL PUNTO (x,y,z)  A LA ESFERA CENTRADA EN EL ORIGEN
-- Parámetros
-- 'vector' es el vector en 3D cuyo plano tangente a la esfera queremos hallar.
-- 'alpha' es el ángulo que rotamos la base v1, v2 del plano tangente
--       en el punto superior de la esfera (0,0,1) o r=1, theta=0, phi=0
-- 's1' y 's2' son factores de escala para los vectores v1 y v2.
-- Nota: Los vectores que se representan en minúsculas están entre paréntesis.
--       Si aparecen en máyúscula, entonces están en una tabla.
function sphereTanPlane(vector, alpha, s1, s2)
   -- Tabla donde almacenar 'vector'
   local P, V1, V2, v1, v2
   local PT1, PT2, PT3, PT4
   local xval, yval, sinalpha, cosalpha

   -- Base de vectores en el plano tangente del punto superior P(0,0,1)
   -- de la esfera para poder dibujar el plano tangente rectangular
   v1 = "(1,0,0)"
   v2 = "(0,1,0)"
   
   --[[DEBUG:
      print("Función: sphereTangPlane(vector, alpha, s1, s2)")
      print("vector = " .. vector)
   --]]
   -- Conseguimos tabla de coordenadas rectangulares y esféricas
   -- P.x, P.y, P.z, P.r, P.theta, P.phi
   P = point3DToTable(vector)
   --[[DEBUG:
      print("P.x = " .. P.x)
      print("P.y = " .. P.y)
      print("P.z = " .. P.z)
      print("P.r = " .. P.r)
      print("P.theta = " .. P.theta)
      print("P.phi = " .. P.phi)
      print()
   --]]

   --[[DEBUG:
      print("v1 antes de rotarlo")
      print("v1 = " .. v1)
   --]]
   V1 = point3DToTable(v1)
   --[[DEBUG:
      print("V1.x = " .. V1.x)
      print("V1.y = " .. V1.y)
      print("V1.z = " .. V1.z)
      print("V1.r = " .. V1.r)
      print("V1.theta = " .. V1.theta)
      print("V1.phi = " .. V1.phi)
      print()
   --]]

   --[[DEBUG:
      print("v2 antes de rotarlo")
      print("v2 = " .. v2)
   --]]
   V2 = point3DToTable(v2)
   --[[DEBUG:
      print("V2.x = " .. V2.x)
      print("V2.y = " .. V2.y)
      print("V2.z = " .. V2.z)
      print("V2.r = " .. V2.r)
      print("V2.theta = " .. V2.theta)
      print("V2.phi = " .. V2.phi)
      print()
   --]]

   -- Rotamos base de vectores v1 y v2
   sinalpha = math.sin(math.rad(alpha))
   sinalpha = sinalpha - sinalpha % 1e-15
   cosalpha = math.cos(math.rad(alpha))
   cosalpha = cosalpha - cosalpha % 1e-15

   --[[DEBUG:
   print()
   print("ROTAMOS BASE V1 y V2")
   print("***********")
   print("alpha = " .. alpha)
   print("sin(alpha) = " .. sinalpha)
   print("cos(alpha) = " .. cosalpha)
   print("***********")
   print()
   --]]
   
   -- V1
   xval = V1.x * cosalpha - V1.y * sinalpha
   yval = V1.x * sinalpha + V1.y * cosalpha
   zval = V1.z
   --
   V1.x = xval
   V1.y = yval
   V1.z = zval   
   -- Completa coordenadas esféricas
   V1 = completeSphericalCoordsTable(V1)
   
   -- V2
   xval = V2.x * cosalpha - V2.y * sinalpha
   yval = V2.x * sinalpha + V2.y * cosalpha
   zval = V2.z
   --
   V2.x = xval
   V2.y = yval
   V2.z = zval   
   -- Completa coordenadas esféricas
   V2 = completeSphericalCoordsTable(V2)

   --[[DEBUG:
      print("V1 después de rotarlo un ángulo 'alpha' alrededor del eje z")
      print("V1.x = " .. V1.x)
      print("V1.y = " .. V1.y)
      print("V1.z = " .. V1.z)
      print("V1.r = " .. V1.r)
      print("V1.theta = " .. V1.theta)
      print("V1.phi = " .. V1.phi)
      print()
   --]]

   --[[DEBUG:
      print("V2 después de rotarlo un ángulo 'alpha' alrededor del eje z")
      print("V2.x = " .. V2.x)
      print("V2.y = " .. V2.y)
      print("V2.z = " .. V2.z)
      print("V2.r = " .. V2.r)
      print("V2.theta = " .. V2.theta)
      print("V2.phi = " .. V2.phi)
      print()
   --]]
   
   PT1, PT2, PT3, PT4 = calcSphereTangPlanePoints(P, V1, V2, s1, s2)
   --[[DEBUG:
   print("Después de llamar a 'calcSphereTangPlanePoints(P, V1, V2, s1, s2)'")
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
   --]]
   
   return pathTanPlane(PT1, PT2, PT3, PT4)
end
-- ****************************************************************************


-- ****************************************************************************
-- FUNCIÓN DE USUARIO
-- (01b) **********************************************************************
-- PLANO TANGENTE EN EL PUNTO "r theta phi" A LA ESFERA CENTRADA EN EL ORIGEN
-- Parámetros
-- 'vectorP' es el vector en 3D cuyo plano tangente a la esfera queremos hallar.
-- 'alpha' es el ángulo que rotamos la base v1, v2 del plano tangente
--       en el punto superior de la esfera (0,0,1) o r=1, theta=0, phi=0
-- 's1' y 's2' son factores de escala para los vectores v1 y v2.
-- Nota: Los vectores que se representan en minúsculas están entre paréntesis.
--       Si aparecen en máyúscula, entonces están en una tabla.
function sphereTanPlaneSph(r, theta, phi, alpha, s1, s2)
   -- Tabla donde almacenar 'vectorP'
   local P, V1, V2, v1, v2

   -- Base de vectores en el plano tangente del punto superior P(0,0,1)
   -- de la esfera para poder dibujar el plano tangente rectangular
   v1 = "(1,0,0)"
   v2 = "(0,1,0)"
   
   --[[DEBUG:
      print("-----------------------------------------------------------")
      print("Función: sphereTangPlaneSph(r, theta, phi, alpha, s1, s2)")
      print("r = " .. r)
      print("theta = " .. theta)
      print("phi = " .. phi)
   --]]
   -- Conseguimos tabla de coordenadas rectangulares y esféricas
   -- a partir de las esféricas
   -- P.x, P.y, P.z, P.r, P.theta, P.phi
   P = point3DToTableSph(r,theta,phi)
   --[[DEBUG:
      print("P.r = " .. P.r)
      print("P.theta = " .. P.theta)
      print("P.phi = " .. P.phi)
      print("P.x = " .. P.x)
      print("P.y = " .. P.y)
      print("P.z = " .. P.z)
      print()
   --]]

   --[[DEBUG:
      print("v1 antes de rotarlo")
      print("v1 = " .. v1)
   --]]
   V1 = point3DToTable(v1)
   --[[DEBUG:
      print("V1.r = " .. V1.r)
      print("V1.theta = " .. V1.theta)
      print("V1.phi = " .. V1.phi)
      print("V1.x = " .. V1.x)
      print("V1.y = " .. V1.y)
      print("V1.z = " .. V1.z)
      print()
   --]]

   --[[DEBUG:
      print("v2 antes de rotarlo")
      print("v2 = " .. v2)
   --]]
   V2 = point3DToTable(v2)
   --[[DEBUG:
      print("V2.r = " .. V2.r)
      print("V2.theta = " .. V2.theta)
      print("V2.phi = " .. V2.phi)
      print("V2.x = " .. V2.x)
      print("V2.y = " .. V2.y)
      print("V2.z = " .. V2.z)
      print()
   --]]

    -- Rotamos base de vectores v1 y v2
   sinalpha = math.sin(math.rad(alpha))
   sinalpha = sinalpha - sinalpha % 1e-15
   cosalpha = math.cos(math.rad(alpha))
   cosalpha = cosalpha - cosalpha % 1e-15

   --[[DEBUG:
   print()
   print("ROTAMOS BASE V1 y V2")
   print("***********")
   print("alpha = " .. alpha)
   print("sin(alpha) = " .. sinalpha)
   print("cos(alpha) = " .. cosalpha)
   print("***********")
   print()
   --]]
   
   -- V1
   xval = V1.x * cosalpha - V1.y * sinalpha
   yval = V1.x * sinalpha + V1.y * cosalpha
   zval = V1.z
   --
   V1.x = xval
   V1.y = yval
   V1.z = zval   
   -- Completa coordenadas esféricas
   V1 = completeSphericalCoordsTable(V1)
   
   -- V2
   xval = V2.x * cosalpha - V2.y * sinalpha
   yval = V2.x * sinalpha + V2.y * cosalpha
   zval = V2.z
   --
   V2.x = xval
   V2.y = yval
   V2.z = zval   
   -- Completa coordenadas esféricas
   V2 = completeSphericalCoordsTable(V2)

   --[[DEBUG:
      print("V1 después de rotarlo un ángulo 'alpha' alrededor del eje z")
      print("V1.x = " .. V1.x)
      print("V1.y = " .. V1.y)
      print("V1.z = " .. V1.z)
      print("V1.r = " .. V1.r)
      print("V1.theta = " .. V1.theta)
      print("V1.phi = " .. V1.phi)
      print()
   --]]

   --[[DEBUG:
      print("V2 después de rotarlo un ángulo 'alpha' alrededor del eje z")
      print("V2.x = " .. V2.x)
      print("V2.y = " .. V2.y)
      print("V2.z = " .. V2.z)
      print("V2.r = " .. V2.r)
      print("V2.theta = " .. V2.theta)
      print("V2.phi = " .. V2.phi)
      print()
   --]]
      
   PT1, PT2, PT3, PT4 = calcSphereTangPlanePoints(P, V1, V2, s1, s2)
   --[[DEBUG:
   print("Después de llamar a 'calcSphereTangPlanePoints(P, V1, V2, s1, s2)'")
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
   --]]

   return pathTanPlane(PT1, PT2, PT3, PT4)
end
-- **************************************************************************


-- ****************************************************************************
-- FUNCIÓN DE USUARIO
-- (02a) **********************************************************************
-- PATH DE UN VECTOR CON ORIGEN EN EL PUNTO p(x,y,z) Y EXTREMO EN v=(x',y',z')
-- RELATIVO A SU ORIGEN.
-- Parámetros
-- 'p' es el origen del vector a representar.
-- 'v' es el extremo del vector con coordenadas relativas a su origen.
-- 's' es un factor de escala del vector.
-- Nota: Los vectores que se representan en minúsculas están entre paréntesis.
--       Si aparecen en máyúscula, entonces están en una tabla.
function vectorAtPoint(p, v, s)
   -- Tablas donde almacenar los vectores
   -- P: Origen del vector en coordenadas absolutas.
   -- V: Extremo del vector en coordenadas relativas a P.
   -- E: Extremo del vector escalado en coordenadas absolutas.
   local P, V, E
   local xval, yval, sinalpha, cosalpha
   
   --[[DEBUG:
      print("Función: vectorInPoint(p, v, s)")
      print("p = " .. p)
   --]]

   -- Conseguimos tabla de coordenadas rectangulares y esféricas
   -- del origen del vector:
   -- P.x, P.y, P.z, P.r, P.theta, P.phi
   P = point3DToTable(p)
   --[[DEBUG:
      print("P.x = " .. P.x)
      print("P.y = " .. P.y)
      print("P.z = " .. P.z)
      print("P.r = " .. P.r)
      print("P.theta = " .. P.theta)
      print("P.phi = " .. P.phi)
      print()
   --]]

   --[[DEBUG:
      print("'v' antes de escalarlo y rotarlo")
      print("v = " .. v)
   --]]
   -- Conseguimos tabla de coordenadas rectangulares y esféricas
   -- del extremo del vector_
   -- V.x, V.y, V.z, V.r, V.theta, V.phi
   V = point3DToTable(v)
   --[[DEBUG:
      print("V.x = " .. V.x)
      print("V.y = " .. V.y)
      print("V.z = " .. V.z)
      print("V.r = " .. V.r)
      print("V.theta = " .. V.theta)
      print("V.phi = " .. V.phi)
      print()
   --]]

   -- Escalamos el vector manteniendo los ángulos V.theta y V.phi originales
   V.r = s * V.r
   -- Completamos las coordenadas rectangulares
   V =point3DToTableSph(V.r, V.theta, V.phi)
   --[[DEBUG:
      print("Vector a representar escalado con s = " .. s)
      print("V.x = " .. V.x)
      print("V.y = " .. V.y)
      print("V.z = " .. V.z)
      print("V.r = " .. V.r)
      print("V.theta = " .. V.theta)
      print("V.phi = " .. V.phi)
      print()
   --]]

   -- Extremo del vector a representar en coordenadas absolutas
   E = {}
   E.x = P.x + V.x
   E.y = P.y + V.y
   E.z = P.z + V.z
   -- Completamos sus coordenadas esféricas
   E = completeSphericalCoordsTable(E)
   --[[DEBUG:
      print("Extremo del vector en coordenadas absolutas:")
      print("E.x = " .. E.x)
      print("E.y = " .. E.y)
      print("E.z = " .. E.z)
      print("E.r = " .. E.r)
      print("E.theta = " .. E.theta)
      print("E.phi = " .. E.phi)
      print()
   --]]
     
   return pathVector(P, E)
end
-- ****************************************************************************


-- ****************************************************************************
-- FUNCIÓN DE USUARIO
-- (02b) **********************************************************************
-- PATH DE UN VECTOR CON ORIGEN EN EL PUNTO p(x,y,z) Y EXTREMO EN v=(x',y',z')
-- RELATIVO A SU ORIGEN.
-- Parámetros
-- 'p' es el origen del vector a representar.
-- 'v' es el extremo del vector con coordenadas relativas a su origen.
-- 's' es un factor de escala del vector.
-- Nota: Los vectores que se representan en minúsculas están entre paréntesis.
--       Si aparecen en máyúscula, entonces están en una tabla.
function vectorAtPointSph(r, theta, phi, v, s)
   -- Tablas donde almacenar los vectores
   -- P: Origen del vector en coordenadas absolutas.
   -- V: Extremo del vector en coordenadas relativas a P.
   -- E: Extremo del vector escalado en coordenadas absolutas.
   local P, V, E
   
   --[[DEBUG:
      print("Función: vectorAtPointSph(r, theta, phi, v, s)")
      print("r = " .. r)
      print("theta = " .. theta)
      print("phi = " .. phi)
   --]]

   -- Conseguimos tabla de coordenadas rectangulares y esféricas
   -- del origen del vector:
   -- P.x, P.y, P.z, P.r, P.theta, P.phi
   P = point3DToTableSph(r, theta, phi)
   --[[DEBUG:
      print("P.r = " .. P.r)
      print("P.theta = " .. P.theta)
      print("P.phi = " .. P.phi)
      print("P.x = " .. P.x)
      print("P.y = " .. P.y)
      print("P.z = " .. P.z)
      print()
   --]]

   --[[DEBUG:
      print("'v' antes de escalarlo y rotarlo")
      print("v = " .. v)
   --]]
   -- Conseguimos tabla de coordenadas rectangulares y esféricas
   -- del extremo del vector_
   -- V.x, V.y, V.z, V.r, V.theta, V.phi
   V = point3DToTable(v)
   --[[DEBUG:
      print("V.x = " .. V.x)
      print("V.y = " .. V.y)
      print("V.z = " .. V.z)
      print("V.r = " .. V.r)
      print("V.theta = " .. V.theta)
      print("V.phi = " .. V.phi)
      print()
   --]]

   -- Escalamos el vector manteniendo los ángulos V.theta y V.phi originales
   V.r = s * V.r
   -- Completamos las coordenadas rectangulares
   V =point3DToTableSph(V.r, V.theta, V.phi)
   --[[DEBUG:
      print("Vector a representar escalado con s = " .. s)
      print("V.x = " .. V.x)
      print("V.y = " .. V.y)
      print("V.z = " .. V.z)
      print("V.r = " .. V.r)
      print("V.theta = " .. V.theta)
      print("V.phi = " .. V.phi)
      print()
   --]]

   -- Extremo del vector a representar en coordenadas absolutas
   E = {}
   E.x = P.x + V.x
   E.y = P.y + V.y
   E.z = P.z + V.z
   -- Completamos sus coordenadas esféricas
   E = completeSphericalCoordsTable(E)
   --[[DEBUG:
      print("Extremo del vector en coordenadas absolutas:")
      print("E.x = " .. E.x)
      print("E.y = " .. E.y)
      print("E.z = " .. E.z)
      print("E.r = " .. E.r)
      print("E.theta = " .. E.theta)
      print("E.phi = " .. E.phi)
      print()
   --]]
     
   return pathVector(P, E)
end
-- ****************************************************************************


-- ****************************************************************************
-- FUNCIÓN DE USUARIO
-- (03a) **********************************************************************
-- VECTOR NORMAL A LA ESFERA CENTRADA EN EL ORIGEN EN UN PUNTO (x,y,z)
-- Parámetros
-- 'p' es el vector en 3D normal a la esfera centrada en el origen.
-- 's' es el tamaño del vector.
-- Nota: Los vectores que se representan en minúsculas están entre paréntesis.
--       Si aparecen en máyúscula, entonces están en una tabla.
function sphereNormalVectorAtPoint(p, s)
   -- Tablas
   local P, V, E

   --[[DEBUG:
      print("Función: sphereNormalVectorAtPoint(p, s)")
      print("p = " .. p)
      print("s = " .. s)
   --]]
   -- Conseguimos tabla de coordenadas rectangulares y esféricas
   -- P.x, P.y, P.z, P.r, P.theta, P.phi
   P = point3DToTable(p)
   --[[DEBUG:
      print("P.x = " .. P.x)
      print("P.y = " .. P.y)
      print("P.z = " .. P.z)
      print("P.r = " .. P.r)
      print("P.theta = " .. P.theta)
      print("P.phi = " .. P.phi)
      print()
   --]]

   -- Consigo vector unidad
   V = {}
   V.r = 1
   V.theta = P.theta
   V.phi = P.phi
   -- Completa coordenadas esféricas
   V = point3DToTableSph(V.r, V.theta, V.phi)

   -- Extremo del vector a representar en coordenadas absolutas
   E = {}
   E.x = P.x + V.x
   E.y = P.y + V.y
   E.z = P.z + V.z
   -- Completamos sus coordenadas esféricas
   E = completeSphericalCoordsTable(E)
   --[[DEBUG:
      print("Extremo del vector en coordenadas absolutas:")
      print("E.x = " .. E.x)
      print("E.y = " .. E.y)
      print("E.z = " .. E.z)
      print("E.r = " .. E.r)
      print("E.theta = " .. E.theta)
      print("E.phi = " .. E.phi)
      print()
   --]]
     
   return pathVector(P, E)
end
-- ****************************************************************************


-- ****************************************************************************
-- FUNCIÓN DE USUARIO
-- (03b) **********************************************************************
-- VECTOR NORMAL A LA ESFERA CENTRADA EN EL ORIGEN EN UN PUNTO r, theta, phi
-- Parámetros
-- 'r', 'theta' y 'phi' son las coordenadas esféricas del punto.
-- 's' es el tamaño del vector.
-- Nota: Los vectores que se representan en minúsculas están entre paréntesis.
--       Si aparecen en máyúscula, entonces están en una tabla.
function sphereNormalVectorAtPointSph(r, theta, phi, s)
   -- Tablas
   local P, V, E

   --[[DEBUG:
      print("Función: vectorAtPointSph(r, theta, phi, v, s)")
      print("r = " .. r)
      print("theta = " .. theta)
      print("phi = " .. phi)
   --]]

   -- Conseguimos tabla de coordenadas rectangulares y esféricas
   -- del origen del vector:
   -- P.x, P.y, P.z, P.r, P.theta, P.phi
   P = point3DToTableSph(r, theta, phi)
   --[[DEBUG:
      print("P.r = " .. P.r)
      print("P.theta = " .. P.theta)
      print("P.phi = " .. P.phi)
      print("P.x = " .. P.x)
      print("P.y = " .. P.y)
      print("P.z = " .. P.z)
      print()
   --]]

   -- Consigo vector unidad
   V = {}
   V.r = 1
   V.theta = P.theta
   V.phi = P.phi
   -- Completa coordenadas esféricas
   V = point3DToTableSph(V.r, V.theta, V.phi)

   -- Extremo del vector a representar en coordenadas absolutas
   E = {}
   E.x = P.x + V.x
   E.y = P.y + V.y
   E.z = P.z + V.z
   -- Completamos sus coordenadas esféricas
   E = completeSphericalCoordsTable(E)
   --[[DEBUG:
      print("Extremo del vector en coordenadas absolutas:")
      print("E.x = " .. E.x)
      print("E.y = " .. E.y)
      print("E.z = " .. E.z)
      print("E.r = " .. E.r)
      print("E.theta = " .. E.theta)
      print("E.phi = " .. E.phi)
      print()
   --]]
     
   return pathVector(P, E)
end
-- ****************************************************************************



-- ****************************************************************************
-- FUNCIÓN DE USUARIO
-- (04a) **********************************************************************
-- VECTOR EN EL PLANO TANGENTE AL PUNTO r, theta, phi DE LA ESFERA CENTRADA
-- EN EL ORIGEN
-- Parámetros
-- 'p' es el punto de tangencia y origen del vector 'v'
-- 'v' es el vector en el plano tangente como si fuera el xy: (x, y).
-- 'alpha': ángulo de rotación de 'v' alrededor de la normal al plano.
-- 's' es el tamaño del vector.
-- Nota: Los vectores que se representan en minúsculas están entre paréntesis.
--       Si aparecen en máyúscula, entonces están en una tabla.
function sphereVectorAtTanPlane(p, v, alpha, s)
   -- Tabla donde almacenar 'vector'
   local P, V, E
   local xval, yval, sinalpha, cosalpha

   ---[[DEBUG:
      print("Función: sphereVectorAtTanPlane(p, v, alpha, s)")
      print("p = " .. p)
   --]]
   -- Conseguimos tabla de coordenadas rectangulares y esféricas
   -- P.x, P.y, P.z, P.r, P.theta, P.phi
   P = point3DToTable(p)
   --[[DEBUG:
      print("P.x = " .. P.x)
      print("P.y = " .. P.y)
      print("P.z = " .. P.z)
      print("P.r = " .. P.r)
      print("P.theta = " .. P.theta)
      print("P.phi = " .. P.phi)
      print()
   --]]

   --[[DEBUG:
      print("v antes de rotarlo")
      print("v = " .. v)
   --]]
   V = vector2DToTable(v)
   --[[DEBUG:
      print("V.x = " .. V.x)
      print("V.y = " .. V.y)
      print("V.r = " .. V.r)
      print("V.phi = " .. V.phi)
      print()
   --]]

   -- Escalamos V
   V.r = s * V.r
   V.x = V.r * math.cos(math.rad(V.phi))
   V.x = V.x - V.x % 1e-15
   V.y = V.r * math.sin(math.rad(V.phi))
   V.y = V.y - V.y % 1e-15   
   --[[DEBUG:
      print("V después de escalarlo a s = " .. s)
      print("V.x = " .. V.x)
      print("V.y = " .. V.y)
      print("V.r = " .. V.r)
      print("V.phi = " .. V.phi)
      print()
   --]]

   -- Rotamos el vector V
   sinalpha = math.sin(math.rad(alpha))
   sinalpha = sinalpha - sinalpha % 1e-15
   cosalpha = math.cos(math.rad(alpha))
   cosalpha = cosalpha - cosalpha % 1e-15

   --[[DEBUG:
   print()
   print("ROTAMOS V")
   print("***********")
   print("alpha = " .. alpha)
   print("sin(alpha) = " .. sinalpha)
   print("cos(alpha) = " .. cosalpha)
   print("***********")
   print()
   --]]
   
   -- V
   xval = V.x * cosalpha - V.y * sinalpha
   yval = V.x * sinalpha + V.y * cosalpha
   --
   V.x = xval
   V.y = yval

   -- Completa coordenadas polares
   V = completePolarCoordsTable(V)
   
  --[[DEBUG:
      print("V después de rotarlo un ángulo 'alpha' en el plano tangente")
      print("V.x = " .. V.x)
      print("V.y = " .. V.y)
      print("V.r = " .. V.r)
      print("V.phi = " .. V.phi)
      print()
   --]]

   -- Extremo del vector a representar en coordenadas absolutas
   E = {}
   E.x = 0 + V.x
   E.y = 0 + V.y
   E.z = 1
   -- Completamos sus coordenadas esféricas
   E = completeSphericalCoordsTable(E)
   --[[DEBUG:
      print("Extremo del vector en coordenadas absolutas:")
      print("E.x = " .. E.x)
      print("E.y = " .. E.y)
      print("E.z = " .. E.z)
      print("E.r = " .. E.r)
      print("E.theta = " .. E.theta)
      print("E.phi = " .. E.phi)
      print()
   --]]


   -- Rotamos vector E de acuerdo con las coordenadas
   -- theta y phi del punto de tangencia P:
   -- Dos giros:
   --    Primero - giro de theta alrededor del eje x
   --    Segundo - giro de phi alrededor del eje z
   
   sintheta = math.sin(math.rad(P.theta))
   sintheta = sintheta - sintheta % 1e-15
   costheta = math.cos(math.rad(P.theta))
   costheta = costheta - costheta % 1e-15
   --
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
   
--   -- Rotación de E (extremo del vector)
   xval = E.x * cosphi * costheta
   xval = xval - E.y * sinphi
   xval = xval + E.z * cosphi * sintheta
   --
   yval = E.x * sinphi * costheta
   yval = yval + E.y * cosphi
   yval = yval + E.z * sinphi * sintheta
   --
   zval = -E.x * sintheta + E.z * costheta
   --
   E.x = xval
   E.y = yval
   E.z = zval

--
--   --[[DEBUG:
--   print("Después de rotar extremo del vector E")
--   print("E.x = " .. E.x)
--   print("E.y = " .. E.y)
--   print("E.z = " .. E.z)
--   print()
--   --]]

   return pathVector(P, E)
end
-- ****************************************************************************


-- ****************************************************************************
-- FUNCIÓN DE USUARIO
-- (04b) **********************************************************************
-- VECTOR EN EL PLANO TANGENTE AL PUNTO r, theta, phi DE LA ESFERA CENTRADA
-- EN EL ORIGEN
-- Parámetros
-- 'r', 'theta', 'phi' coordenadas esféricas del punto de tangencia
-- 'v' es el vector en el plano tangente como si fuera el xy: (x, y).
-- 'alpha': ángulo de rotación de 'v' alrededor de la normal al plano.
-- 's' es el tamaño del vector.
-- Nota: Los vectores que se representan en minúsculas están entre paréntesis.
--       Si aparecen en máyúscula, entonces están en una tabla.
function sphereVectorAtTanPlaneSph(r, theta, phi, v, alpha, s)
   -- Tabla donde almacenar 'vector'
   local P, V, E
   local xval, yval, sinalpha, cosalpha
   local zval, sintheta, costheta, sinphi, cosphi

   --[[DEBUG:
      print("Función: sphereVectorAtTanPlaneSph(r, theta, phi, v, alpha, s)")
      print("r = " .. r)
      print("theta = " .. theta)
      print("phi = " .. phi)
   --]]

   -- Conseguimos tabla de coordenadas rectangulares y esféricas
   -- del origen del vector:
   -- P.x, P.y, P.z, P.r, P.theta, P.phi
   P = point3DToTableSph(r, theta, phi)
   --[[DEBUG:
      print("P.r = " .. P.r)
      print("P.theta = " .. P.theta)
      print("P.phi = " .. P.phi)
      print("P.x = " .. P.x)
      print("P.y = " .. P.y)
      print("P.z = " .. P.z)
      print()
   --]]

   --[[DEBUG:
      print("v antes de rotarlo")
      print("v = " .. v)
   --]]
   V = vector2DToTable(v)
   --[[DEBUG:
      print("V.x = " .. V.x)
      print("V.y = " .. V.y)
      print("V.r = " .. V.r)
      print("V.phi = " .. V.phi)
      print()
   --]]

   -- Escalamos V
   V.r = s * V.r
   V.x = V.r * math.cos(math.rad(V.phi))
   V.x = V.x - V.x % 1e-15
   V.y = V.r * math.sin(math.rad(V.phi))
   V.y = V.y - V.y % 1e-15   
   --[[DEBUG:
      print("V después de escalarlo a s = " .. s)
      print("V.x = " .. V.x)
      print("V.y = " .. V.y)
      print("V.r = " .. V.r)
      print("V.phi = " .. V.phi)
      print()
   --]]

   -- Rotamos el vector V
   sinalpha = math.sin(math.rad(alpha))
   sinalpha = sinalpha - sinalpha % 1e-15
   cosalpha = math.cos(math.rad(alpha))
   cosalpha = cosalpha - cosalpha % 1e-15

   --[[DEBUG:
   print()
   print("ROTAMOS V")
   print("***********")
   print("alpha = " .. alpha)
   print("sin(alpha) = " .. sinalpha)
   print("cos(alpha) = " .. cosalpha)
   print("***********")
   print()
   --]]
   
   -- V
   xval = V.x * cosalpha - V.y * sinalpha
   yval = V.x * sinalpha + V.y * cosalpha
   --
   V.x = xval
   V.y = yval

   -- Completa coordenadas polares
   V = completePolarCoordsTable(V)
   
  --[[DEBUG:
      print("V después de rotarlo un ángulo 'alpha' en el plano tangente")
      print("V.x = " .. V.x)
      print("V.y = " .. V.y)
      print("V.r = " .. V.r)
      print("V.phi = " .. V.phi)
      print()
   --]]

   -- Extremo del vector a representar en coordenadas absolutas
   E = {}
   E.x = 0 + V.x
   E.y = 0 + V.y
   E.z = 1
   -- Completamos sus coordenadas esféricas
   E = completeSphericalCoordsTable(E)
   --[[DEBUG:
      print("Extremo del vector en coordenadas absolutas antes de rotarlo:")
      print("E.x = " .. E.x)
      print("E.y = " .. E.y)
      print("E.z = " .. E.z)
      print("E.r = " .. E.r)
      print("E.theta = " .. E.theta)
      print("E.phi = " .. E.phi)
      print()
   --]]


   -- Rotamos vector E de acuerdo con las coordenadas
   -- theta y phi del punto de tangencia P:
   -- Dos giros:
   --    Primero - giro de theta alrededor del eje x
   --    Segundo - giro de phi alrededor del eje z
   
   sintheta = math.sin(math.rad(P.theta))
   sintheta = sintheta - sintheta % 1e-15
   costheta = math.cos(math.rad(P.theta))
   costheta = costheta - costheta % 1e-15
   --
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
   
--   -- Rotación de E (extremo del vector)
   xval = E.x * cosphi * costheta
   xval = xval - E.y * sinphi
   xval = xval + E.z * cosphi * sintheta
   --
   yval = E.x * sinphi * costheta
   yval = yval + E.y * cosphi
   yval = yval + E.z * sinphi * sintheta
   --
   zval = -E.x * sintheta + E.z * costheta
   --
   E.x = xval
   E.y = yval
   E.z = zval

--
--   --[[DEBUG:
--   print("Después de rotar extremo del vector E")
--   print("E.x = " .. E.x)
--   print("E.y = " .. E.y)
--   print("E.z = " .. E.z)
--   print()
--   --]]

   return pathVector(P, E)
end
-- ****************************************************************************


-- ****************************************************************************
-- FUNCIÓN DE USUARIO
-- (05a) **********************************************************************
-- PATH DE UN PUNTO P(x,y,z)
-- Parámetros
-- 'p' es el punto a representar (x,y,z)
-- Nota: Los vectores que se representan en minúsculas están entre paréntesis.
--       Si aparecen en máyúscula, entonces están en una tabla.
function point(p)
   -- Tabla donde almacenar las coordenadas del punto
   local P

   --[[DEBUG:
      print("Función: point(p)")
      print("p = " .. p)
   --]]
   -- Conseguimos tabla de coordenadas rectangulares y esféricas
   -- P.x, P.y, P.z, P.r, P.theta, P.phi
   P = point3DToTable(p)
   --[[DEBUG:
      print("Coordenadas de P antes de rotarlo:")
      print("P.x = " .. P.x)
      print("P.y = " .. P.y)
      print("P.z = " .. P.z)
      print("P.r = " .. P.r)
      print("P.theta = " .. P.theta)
      print("P.phi = " .. P.phi)
      print()
   --]]
   
   return pathPoint(P)
end
-- ****************************************************************************


-- ****************************************************************************
-- FUNCIÓN DE USUARIO
-- (05b) **********************************************************************
-- PATH DE UN PUNTO r, theta, phi
-- Parámetros
-- 'r', 'theta' y 'phi' son las coordenadas esféricas del punto a representar.
-- Nota: Los vectores que se representan en minúsculas están entre paréntesis.
--       Si aparecen en máyúscula, entonces están en una tabla.
function pointSph(r, theta, phi)
   -- Tabla donde almacenar las coordenadas del punto
   local P

   --[[DEBUG:
      print("Función: pointSph(r, theta, phi)")
      print("r = " .. r)
      print("theta = " .. theta)
      print("phi = " .. phi)
      print()
   --]]

   -- Conseguimos tabla de coordenadas rectangulares y esféricas
   -- del origen del vector:
   -- P.x, P.y, P.z, P.r, P.theta, P.phi
   P = point3DToTableSph(r, theta, phi)
   --[[DEBUG:
      print("Coordenadas de P:")
      print("P.r = " .. P.r)
      print("P.theta = " .. P.theta)
      print("P.phi = " .. P.phi)
      print("P.x = " .. P.x)
      print("P.y = " .. P.y)
      print("P.z = " .. P.z)
   --]]
   
   return pathPoint(P)
end
-- ****************************************************************************


-- ****************************************************************************
-- FUNCIÓN DE USUARIO
-- (06a) **********************************************************************
-- VECTOR RADIAL EN EL PUNTO r, theta, phi DE LA ESFERA CENTRADA EN EL ORIGEN
-- Parámetros
-- 'r', 'theta', 'phi' coordenadas esféricas del punto de tangencia
-- 's' es el tamaño del vector.
-- Nota: Los vectores que se representan en minúsculas están entre paréntesis.
--       Si aparecen en máyúscula, entonces están en una tabla.
function radialVectorAtPointSph(sr, stheta, sphi, ss)
   -- Tabla donde almacenar 'vector'
   local P, E
   local r, theta, phi, s

   r = tonumber(sr)
   theta = tonumber(stheta)
   phi = tonumber(sphi)
   s = tonumber(ss)

   --[[DEBUG:
      print("Función: radialVectorAtPointSph(sr, stheta, sphi, ss)")
      print("r = " .. r)
      print("theta = " .. theta)
      print("phi = " .. phi)
      print("s = " .. s)
   --]]

   -- Conseguimos tabla de coordenadas rectangulares y esféricas
   -- del origen del vector:
   -- P.x, P.y, P.z, P.r, P.theta, P.phi
   P = point3DToTableSph(r, theta, phi)
   --[[DEBUG:
      print("P.r = " .. P.r)
      print("P.theta = " .. P.theta)
      print("P.phi = " .. P.phi)
      print("P.x = " .. P.x)
      print("P.y = " .. P.y)
      print("P.z = " .. P.z)
      print()
   --]]

   -- Extremo del vector a representar en coordenadas absolutas
   E = point3DToTableSph(r+s, theta, phi)   
   --[[DEBUG:
      print("Extremo del vector:")
      print("E.x = " .. E.x)
      print("E.y = " .. E.y)
      print("E.z = " .. E.z)
      print("E.r = " .. E.r)
      print("E.theta = " .. E.theta)
      print("E.phi = " .. E.phi)
      print()
   --]]

   return pathVector(P, E)
end
-- ****************************************************************************








-- #########################################################################

-- Función auxiliar
-- (03) *********************************************************************
-- (x,y,z) -> TABLA: P.x  P.y  P.z  P.r  P.theta  P.phi
function point3DToTable(vector3D)
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











--function getPointRot(alpha,nx,ny,nz,x,y,z)
--   
--end

-- PLANO TANGENTE EN EL PUNTO r, theta, phi A LA ESFERA CENTRADA EN EL ORIGEN
-- Parámetros
-- 'r', 'theta', 'phi' son las coordenadas esféricas del punto
--                     cuyo plano tangente a la esfera queremos hallar.
-- 'v1' y 'v2' son dos vectores que se usan para dibujar el plano rectangular.
-- 's1' y 's2' son factores de escala para los vectores v1 y v2.
-- Nota: Los vectores que se representan en minúsculas están entre paréntesis.
--       Si aparecen en máyúscula, entonces están en una tabla.







--function sphereTangPlane(vectorP, v1, v2, s1, s2)
--   -- Tabla donde almacenar 'vectorP'
--   local P = {}
--   local PT1, PT2, PT3, PT4
--   local xval, yval, zval
--   local str1, str2, str3, str4
--
--   -- Conseguimos tabla de coordenadas rectangulares y esféricas
--   -- P.x, P.y, P.z, P.r, P.theta, P.phi
--   P = setPoint3Dvect(vectorP)
--   V1 = setPoint3Dvect(v1)
--   V2 = setPoint3Dvect(v2)
--
--   -- Los cuatro puntos del plano tangente
--   PT1 = {}; PT2 = {}; PT3 = {}; PT4 = {}
--
--   -- Primer punto tangente
--   xval = P.x + s1 * V1.x + s2 * V2.x
--   yval = P.y + s1 * V1.y + s2 * V2.y
--   zval = P.z + s1 * V1.z + s2 * V2.z
--   PT1 = {x=xval, y=yval, z=zval}
--   str1 = "(" .. PT1.x .. "," .. PT1.y .. "," .. PT1.z .. ")" 
--
--   -- Segundo punto tangente
--   xval = x + s1 * v1x - s2 * v2x
--   yval = y + s1 * v1y - s2 * v2y
--   zval = z + s1 * v1z - s2 * v2z
--   PT2 = {x=xval, y=yval, z=zval}
--   str2 = "(" .. PT2.x .. "," .. PT2.y .. "," .. PT2.z .. ")"
--
--   -- Tercer punto tangente
--   xval = x - s1 * v1x - s2 * v2x
--   yval = y - s1 * v1y - s2 * v2y
--   zval = z - s1 * v1z - s2 * v2z
--   PT3 = {x=xval, y=yval, z=zval}
--   str3 = "(" .. PT3.x .. "," .. PT3.y .. "," .. PT3.z .. ")"
--
--   -- Cuarto punto tangente
--   xval = x - s1 * v1x + s2 * v2x
--   yval = y - s1 * v1y + s2 * v2y
--   zval = z - s1 * v1z + s2 * v2z
--   PT4 = {x=xval, y=yval, z=zval}
--   str4 = "(" .. PT4.x .. "," .. PT4.y .. "," .. PT4.z .. ")"
--
--   return str1 .." -- ".. str2 .." -- ".. str3 .." -- ".. str4
--end





---- 
--function setPoint3Drect(x,y,z)
--local P = {}
--local cosphi, tanphi, rxy
--local sintheta
--
---- Integramos las coordenadas cartesianas en la tabla
--P.x = x
--P.y = y
--P.z = z
---- Integramos coordenadas esféricas en la tabla
--rxy = math.sqrt(P.x^2 + P.y^2)
--cosphi = P.x/rxy
--tanphi = P.y/P.x
---- Ángulo phi
--P.phi = math.deg(math.atan(tanphi))
---- Ahora corrijo si no es así
--if cosphi < 0 then
--	P.phi = P.phi + 180
--end
---- Módulo r
--P.r = math.sqrt(P.x^2 + P.y^2 + P.z^2)
---- Ángulo theta
--sintheta = rxy/P.r
--P.theta = math.deg(math.asin(sintheta))
--if P.theta < 0 then
--	P.theta = 180 - P.theta
--end
---- Si el ángulo phi no está definido 'nan'
---- es porque el ángulo theta es 0,
---- entonces phi=0, por ejemplo
--if P.phi ~= P.phi and P.theta == 0 then
--   P.phi = 0
--end
--
--return P
--end












