
--# Main
-- Font Renderer

-- Use this function to perform your initial setup
function setup()
    noSmooth()
    textIm = image(WIDTH // 8, HEIGHT // 16 // 2)
    setContext(textIm)
    background((" "):byte(), 0,0)
    cmap = image(textIm.width, textIm.height)
    for x = 1, cmap.width do
        for y = 1, cmap.height do
            cmap:set(x, y, color(
                (math.sin(x/2)*128+128)*(cmap.height-y)/cmap.height, 
                (math.sin(x/2+.66*math.pi)*128+128)*(cmap.height-y)/cmap.height, 
                (math.sin(x/2+1.33*math.pi)*128+128)*(cmap.height-y)/cmap.height
            ))
        end
    end
    fmesh = loadFont(ContentScaleFactor*2, textIm, nil and readImage("Documents:char"))
    
    cur = vec2(1,0)
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(255, 255, 255, 255)
    translate(0, HEIGHT //2 - 16)

    -- This sets the line thickness
    strokeWidth(5)
    
    local c = color(textIm:get(cur.x, textIm.height - cur.y))
    c.a = math.floor(ElapsedTime*1.5) % 2
    textIm:set(cur.x, textIm.height - cur.y, c)

    noSmooth()
    -- Do your drawing here
    drawFont(fmesh, textIm, cmap)
    
    c.a = 1
    textIm:set(cur.x, textIm.height - cur.y, c)
    --rfont:draw(0, 100)
    if not isKeyboardShowing() then
        showKeyboard()
    end
end

function keyboard(key)
    if key == "" then
        cur.x = cur.x - 1
        if cur.x < 1 and cur.y ~= 1 then
            cur.x = textIm.width
            cur.y = math.min(1, cur.y + 1)
        end
    elseif key == "\n" then
        cur.x = 1
        cur.y = math.min(textIm.height-1, cur.y + 1)
    else
        textIm:set(cur.x, textIm.height - cur.y, color(key:byte(), 0,0,255))
        cur.x = cur.x + 1
        if cur.x > textIm.width and cur.y ~= textIm.height then
            cur.x = 1
            cur.y = math.max(1, cur.y - 1)
        end
    end
end


--# Render
--[[
fsize = {}
fsize.h = 11     -- height
fsize.xh = 7    -- x-height
fsize.desc = 3  -- descent
fsize.fh = fsize.h + fsize.desc

fsize.w = 10
--]]

--

textren = textren or {}

textren.font = readImage("Documents:FDATA_MODES")

textren.vertex = [[
//
// A basic vertex shader
//

//This is the current model * view * projection matrix
// Codea sets it automatically
uniform mat4 modelViewProjection;

//This is the current mesh vertex position, colo 0and tex coord
// Set automatically
attribute vec4 position;
attribute vec4 color;
attribute vec2 texCoord;

//This is an output variable that will be passed to the fragment shader
varying highp vec4 vColor;
varying highp vec2 vTexCoord;

// ARRAYSETUP

void main()
{
    //Pass the mesh color to the fragment shader
    vColor = color;
    vTexCoord = texCoord;
    
    //Multiply the vertex position by our combined transform
    gl_Position = modelViewProjection * position;
    // ARRAYS
}
]]

textren.fragment = [[
//
// A basic fragment shader
//

//Default precision qualifier
precision highp float;

//This represents the current texture on the mesh
uniform highp sampler2D texture;

//The interpolated vertex color for this fragment
varying vec4 vColor;

//The interpolated texture coordinate for this fragment
varying vec2 vTexCoord;

uniform highp sampler2D font;
uniform highp sampler2D text;
uniform highp sampler2D colormap;

uniform float fw;
uniform float tw;
uniform float fh;

uniform float scale;

uniform float fs;

uniform float tx;

uniform float rows;

void main()
{
    vec2 pos = vec2( gl_FragCoord.xy );
    pos.x -= tx;
    //Sample the texture at the interpolated coordinate
    //highp vec4 col = vColor * texture2D(font, vTexCoord);

    float posInText = vTexCoord.x;
    vec4 ccol = texture2D(text, vec2(posInText, vTexCoord.y));
    float characterX = float(int(ccol.r*255.))/255. * fw;
    float characterY = float(int(ccol.g*255.))/255.;

    float textPos = mod(pos.x, fs * scale) / scale + characterX;
    float textPosShifted = textPos / fw;
    vec4 currentPixel = vec4(1.,1.,1.,texture2D(font, vec2(textPosShifted, mod(vTexCoord.y*rows, 1.0)/fh+characterY)).a);
    //col = currentPixel;

    //col.g = character / fw;

    vec4 cmap = texture2D(colormap, vec2(posInText, vTexCoord.y));

    gl_FragColor = currentPixel * cmap;
    if (ccol.a == .0) {
        gl_FragColor.a = 1. - gl_FragColor.a;
    }
}
]]

--[[
shader("Documents:Dither")
--]]

function loadFont(size, str, font)
    
    local fontShader = shader(textren.vertex, textren.fragment)
    
    -- Create a mesh
    local m = mesh()
    
    -- Set vertices
    m.vertices = triangulate{
        vec2(0,0),
        vec2(str.width*4*size/ContentScaleFactor,0),
        vec2(str.width*4*size/ContentScaleFactor,4*size*str.height),
        vec2(0,4*size*str.height)
    }
    m.texCoords = triangulate{
        vec2(0,0),
        vec2(1,0),
        vec2(1,1),
        vec2(0,1)
    }
                    
    -- Set all vertex colors to white
    m:setColors(color(255))
    
    m.shader = fontShader
    m.shader.font = font or textren.font
    m.shader.text = str
    
    m.shader.rows = str.height
    
    m.shader.texture = m.shader.font
    
    m.shader.scale = size
    
    m.shader.fw = textren.font.width
    m.shader.tw = m.shader.text.width
    
    m.shader.fh = textren.font.height / 8
    
    m.shader.fs = textren.font.width / 255
    
    m.shader.tx = 0--10*size - ElapsedTime*100
    
    return m

end

function drawFont(m, text, colormap)
    m.shader.tx = math.floor((modelMatrix())[13]*2)
    if text then 
        m.shader.text = text
        m.shader.tw = m.shader.text.width
        local s = 4
        m.vertices = triangulate{
            vec2(0,0),--text.height),
            vec2((m.shader.text.width)*s*m.shader.scale/2,0),--text.height-2),
            vec2((m.shader.text.width)*s*m.shader.scale/2,s*m.shader.scale*text.height),
            vec2(0,s*m.shader.scale*text.height)
        }
        m.shader.rows = text.height
        m.shader.colormap = colormap
    end
    m:draw()
    --print(modelMatrix())
end
--loadFont()

function makeText(str, size)
    local _, h = str:gsub("\n", "")
    local w = 0
    for s in (str.."\n"):gmatch(".-\n") do
        w = math.max(w, #s - 1)
    end
    local i = image(w, h)
    local cmap = image(w, h)
    setContext(cmap)
    background(255, 255, 255, 255)
    setContext()
    local x, y = 1, h
    for n = 1, #str do
        if str:sub(n,n) == "\n" then
            x = 1; y = y - 1;
        else
            i:set(x, y, color(str:sub(n,n):byte()))
        end
    end
    return loadFont(size, i, cmap), i, cmap
end
--# RasterFont
RasterFont = class()

function RasterFont:init(t, s)
    -- you can accept and set parameters here
    self.m, self.i, self.cmap = makeText(t, s)
end

function RasterFont:draw(x, y)
    pushMatrix()
    translate(x, -y)
    drawFont(self.m)
    popMatrix()
end

function RasterFont:setChar(c, x, y)
    self.i:set(x, y, color(c:byte()))
end
