module Common.Units where

import qualified Graphics.Rendering.OpenGL as GL
import Common.GLTypes


vertex3   :: GL.GLfloat -> GL.GLfloat -> GL.GLfloat -> GLfVertex3
vector3   :: GL.GLfloat -> GL.GLfloat -> GL.GLfloat -> GLfVector3
color3    :: GL.GLfloat -> GL.GLfloat -> GL.GLfloat -> GLfColor3
color4    :: GL.GLfloat -> GL.GLfloat -> GL.GLfloat -> GL.GLfloat -> GLfColor4
texCoord2 :: GL.GLfloat -> GL.GLfloat -> GLfTexCoord2

vertex3   = GL.Vertex3
vector3   = GL.Vector3
color3    = GL.Color3
color4    = GL.Color4
texCoord2 = GL.TexCoord2

nullVertex3  :: GLfVertex3
nullVector3, nullDimension, nullTranslation :: GLfVector3

nullVertex3     = vertex3 0 0 0
nullVector3     = vector3 0 0 0
nullGeometry    = (nullVector3, nullVector3)
nullDimension   = nullVector3
nullTranslation = nullVector3

negateVector3 :: GLfVector3 -> GLfVector3
negateVector3 (GL.Vector3 x y z) = GL.Vector3 (-x) (-y) (-z)

translation, dimension :: GL.GLfloat -> GL.GLfloat -> GL.GLfloat -> GLfVector3
translation = vector3
dimension   = vector3

colorWhite, colorBlack :: GLfColor4
colorWhite = color4 1 1 1 1
colorBlack = color4 0 0 0 1

