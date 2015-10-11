
--# Main
-- Font Designer

-- Use this function to perform your initial setup

function setup()
    fRaw = "Documents:FDATA_MODES"
    fComp = "Documents:FDATA_COMPRESSED"
    
    noSmooth()
    socket = require"socket"
    fdata = {}
    i = readImage(fRaw)
    F_IM = readImage(fRaw)
    ci = readImage(fComp)
    print(io.open(os.getenv("HOME").."/Documents/FDATA_COMPRESSED.png", "r"))
    i2 = image(i.width*2,i.height*2)
    --print("Images made")
    spriteMode(CORNER)
    --noSmooth()
    setContext(i2)
    sprite(i,0,0,i.width*2, i.height*2)
    setContext()
    --print("Sprites made")
    cc = 1
    cm = i2.width*TYPES-fsize.w
    tab={}
    size=2
    table.insert(tab,Rose(100+size*5,size))
    c=0
    speed = 1000
    displayMode(FULLSCREEN)
    FONTPIX = readImage("Documents:FDATA_COMPRESSED_TESTING")
    SCROLL = 0
    rectMode(CORNER)
    conflicts = {}
    --_ISCHECKING = true
    loading = mesh()
    loading.shader = shader("Documents:Loading")
    loading.vertices = triangulate{
    vec2(-298,-158),
    vec2(-298, -136),
    vec2(298, -136),
    vec2(298, -158)
    }
    loading.texCoords = triangulate{vec2(0,0),vec2(0,1),vec2(1,1),vec2(1,0)}
    loading.shader.texture = image(596,22)
    setContext(loading.shader.texture)
    background(255)
    setContext()
    loading:setColors(color(255))
    --textMode(CORNER)
    font("SourceSansPro-Regular")
    fontSize(22)
    startLoadingTime = socket.gettime()
    --_ISCHECKING = true
    --startRecording()
end

function draw()
    --scale(.75)
    smooth()
    background(255)
    stroke(255, 0, 0) strokeWidth(5) --noSmooth()
    pushMatrix()
    translate(WIDTH/2, HEIGHT/2)
    for a,b in pairs(tab) do
        b:draw()
    end
    --scale(2)
    --popMatrix()
    noSmooth()
    --[[
    noStroke()
    fill(255,200)
    rect(-120+cc/cm*240, -120, 240,240)
    --]]
    setContext(loading.shader.texture)
    background(255)
    stroke(0)
    pushMatrix()
    resetMatrix()
    local ct = socket.gettime() - startLoadingTime
    text(math.floor(cc/cm * 100) .. "% complete (" .. ("%.0f seconds remaining"):format((ct / cc)*(cm-cc)) .. ")", 596/2, 11)
    popMatrix()
    setContext()
    strokeWidth(1)
    stroke(0)
    fill(255)
    rect(-300,-160,600,26)
    fill(0)
    noStroke()
    --rect(-198, -148, cc/cm * 396, 11)
    loading.shader.completed = cc/cm
    loading:draw()
    popMatrix()
    for cc = cc, math.min(cm, cc + fsize.w * speed), fsize.w do
        if _ISCHECKING then
            speed = 5
            fdata[math.ceil(cc/fsize.w)] = fdata[math.ceil(cc/fsize.w)] or {}
            for y = 1, fsize.fh do
                fdata[math.ceil(cc/fsize.w)][y] = fdata[math.ceil(cc/fsize.w)][y] or {}
                for x = 0, fsize.w-1 do
                    local r,g,b,a = i2:get((cc)%i2.width+x, y+math.floor(cc/i2.width)*fsize.fh)
                    --s = s .. a
                    --ch[y][x+1] = a>0 and 1 or 0
                    --if (a>0 and 1 or 0) > 0 then
                    fdata[math.ceil(cc/fsize.w)][y][x+1] = (a>0 and 1 or 0)
                    --end
                end
            end
        else
            local c = math.ceil(cc / fsize.w)
            fdata[c] = {}
            for block = 0, 5 do
                fdata[c][block*3+1] = {}
                if block < 5 then
                    fdata[c][block*3+2] = {}
                    fdata[c][block*3+3] = {}
                end
                local r, g, b, a = ci:get(c, block+1)
                for x = 0, fsize.w-1 do
                    fdata[c][block*3+1][x+1] = (r >> x) & 1
                    if block < 5 then
                        fdata[c][block*3+2][x+1] = (g >> x) & 1
                        fdata[c][block*3+3][x+1] = (b >> x) & 1
                    end
                end
            end
            --]=]
        end
    end
    cc = cc + fsize.w * speed
    --print(cc)
    if cc > cm then
        if not _ISCHECKING then
            setChar(readProjectData("CurrentChar") or ("A"):byte())
            draw = _draw
            touched = _touched
            --alert(#conflicts .. " conflicts found")
            stopRecording()
        else
            cc = 1
            _ISCHECKING = true
        end
    end
end

-- This function gets called once every frame
function _draw()
    -- This sets a dark background color 
    background(255, 255, 255, 255)
    noSmooth()

    -- This sets the line thickness
    strokeWidth(1)
    
    rectMode(CORNER)
    noStroke()
    
    fill(175)
    rect(0,HEIGHT-20,WIDTH,20)
    
    fill(200)
    rect(WIDTH - 100, 0, 100, HEIGHT)
    fill(255,200,200)
    rect(WIDTH-50, 0, 50, HEIGHT/2)
    
    fill(200,200,255)
    rect(WIDTH-50, HEIGHT/2, 50, HEIGHT/2)
    --[[
    fill(255,150,150)
    rect(WIDTH-10, 0, 10, HEIGHT/2)
    
    fill(150,150,255)
    rect(WIDTH-10, HEIGHT/2, 10, HEIGHT/2)
    --]]
    
    fill(0,128,0)
    rect(WIDTH-150,HEIGHT-100,50,100)
    fill(128,0,128)
    rect(WIDTH-150,HEIGHT-200,50,100)

    -- Do your drawing here
    drawUI()
    
    --sprite(FONTPIX, -SCROLL,0)
    --cfont:draw()
end

function _touched(touch)
    SCROLL = SCROLL + touch.deltaX
    if touch.state < ENDED then ctended = false end
    if touch.state == BEGAN then
        if range(touch.x, WIDTH-150,WIDTH-100,touch.y,HEIGHT-200,HEIGHT-100) and fpos > 255 then
            fpos = fpos - 255
        elseif range(touch.x, WIDTH-150,WIDTH-100,touch.y,HEIGHT-100,HEIGHT) then
            fpos = (fpos + 255) % (255 * TYPES)
        elseif touch.x > WIDTH - 50 then
            if touch.y > HEIGHT /2 then
                setChar(fpos - 1)
            else
                if fpos % 255 == 0 then fpos = fpos - 255 end
                setChar(fpos + 1)
            end
        elseif touch.y > HEIGHT - 20 then
            for y, row in ipairs(fdata[fpos]) do
                for x, col in ipairs(row) do
                    fdata[fpos][y][x] = 0
                end
            end
        elseif touch.x > WIDTH - 100 then
            local time = socket.gettime()
            --[[
            local i = image((255) * fsize.w*.5, (fsize.h+fsize.desc)*.5*TYPES)
            setContext(i)
            --background(255, 255, 255, 255)
            --setContext()
            noStroke()
            noSmooth()
            fill(0)
            for c, char in pairs(fdata) do
                for y, row in ipairs(char) do
                    for x, col in ipairs(row) do
                        if col == 1 then
                            --print(c*fsize.w + x, y)
                            --i:set(c*fsize.w + x, y, color(255))
                            rect(((c*fsize.w+x)%(255*fsize.w))*.5-.5, ((y-1)+(math.floor(c/255)*fsize.fh))*.5, .5, .5)
                            --rect(((c*fsize.w+x)%(255*fsize.w))*.5, (y)*.5+math.floor((c*fsize.w+x)/(255*fsize.w)+0), .5, .5)
                        end
                    end
                end
            end
            saveImage("Documents:FDATA_MODES_TESTING", i)
            print("Saved ("..(socket.gettime() - time)..")")
            --]]
            time = socket.gettime()
            saveImage(fComp, compressFont())
            print("Compressed ("..(socket.gettime() - time)..")")
            --[[
            local i = image((255) * fsize.w*.5, (fsize.h+fsize.desc)*.5*TYPES)
            setContext(i)
            --background(255, 255, 255, 255)
            --setContext()
            noStroke()
            noSmooth()
            fill(0)
            for c, char in pairs(fdata) do
                for y, row in ipairs(char) do
                    for x, col in ipairs(row) do
                        if col == 1 then
                            --print(c*fsize.w + x, y)
                            --i:set(c*fsize.w + x, y, color(255))
                            rect(((c*fsize.w+x)%(255*fsize.w))*.5-.5, ((y-1)+(math.floor(c/255)*fsize.fh))*.5, .5, .5)
                            --rect(((c*fsize.w+x)%(255*fsize.w))*.5, (y)*.5+math.floor((c*fsize.w+x)/(255*fsize.w)+0), .5, .5)
                        end
                    end
                end
            end
            saveImage("Documents:FDATA_MODES", i)
            print("Saved ("..(socket.gettime() - time)..")")
            --]]
            saveImage(fRaw, F_IM)
            print("Saved")
        end
    end
end


--# ANSI
ansi = {}

exceptions = {}

ansi[32] = [[ ]]
ansi[33] = [[!]]
ansi[34] = [["]]
ansi[35] = [[#]]
ansi[36] = [[$]]
ansi[37] = [[%]]
ansi[38] = [[&]]
ansi[39] = [[']]
ansi[40] = [[(]]
ansi[41] = [[)]]
ansi[42] = [[*]]
ansi[43] = [[+]]
ansi[44] = [[,]]
ansi[45] = [[-]]
ansi[46] = [[.]]
ansi[47] = [[/]]
ansi[48] = [[0]]
ansi[49] = [[1]]
ansi[50] = [[2]]
ansi[51] = [[3]]
ansi[52] = [[4]]
ansi[53] = [[5]]
ansi[54] = [[6]]
ansi[55] = [[7]]
ansi[56] = [[8]]
ansi[57] = [[9]]
ansi[58] = [[:]]
ansi[59] = [[;]]
ansi[60] = [[<]]
ansi[61] = [[=]]
ansi[62] = [[>]]
ansi[63] = [[?]]
ansi[64] = [[@]]
ansi[65] = [[A]]
ansi[66] = [[B]]
ansi[67] = [[C]]
ansi[68] = [[D]]
ansi[69] = [[E]]
ansi[70] = [[F]]
ansi[71] = [[G]]
ansi[72] = [[H]]
ansi[73] = [[I]]
ansi[74] = [[J]]
ansi[75] = [[K]]
ansi[76] = [[L]]
ansi[77] = [[M]]
ansi[78] = [[N]]
ansi[79] = [[O]]
ansi[80] = [[P]]
ansi[81] = [[Q]]
ansi[82] = [[R]]
ansi[83] = [[S]]
ansi[84] = [[T]]
ansi[85] = [[U]]
ansi[86] = [[V]]
ansi[87] = [[W]]
ansi[88] = [[X]]
ansi[89] = [[Y]]
ansi[90] = [[Z]]
ansi[91] = [[[]]
ansi[92] = [[\]]
ansi[93] = [=[]]=]
ansi[94] = [[^]]
ansi[95] = [[_]]
ansi[96] = [[`]]
ansi[97] = [[a]]
ansi[98] = [[b]]
ansi[99] = [[c]]
ansi[100] = [[d]]
ansi[101] = [[e]]
ansi[102] = [[f]]
ansi[103] = [[g]]
ansi[104] = [[h]]
ansi[105] = [[i]]
ansi[106] = [[j]]
ansi[107] = [[k]]
ansi[108] = [[l]]
ansi[109] = [[m]]
ansi[110] = [[n]]
ansi[111] = [[o]]
ansi[112] = [[p]]
ansi[113] = [[q]]
ansi[114] = [[r]]
ansi[115] = [[s]]
ansi[116] = [[t]]
ansi[117] = [[u]]
ansi[118] = [[v]]
ansi[119] = [[w]]
ansi[120] = [[x]]
ansi[121] = [[y]]
ansi[122] = [[z]]
ansi[123] = [[{]]
ansi[124] = [[|]]
ansi[125] = [[}]]
ansi[126] = [[~]]
ansi[127] = [[ ]]
ansi[128] = [[Ç]]
ansi[129] = [[ü]]
ansi[130] = [[é]]
ansi[131] = [[â]]
ansi[132] = [[ä]]
ansi[133] = [[à]]
ansi[134] = [[å]]
ansi[135] = [[ç]]
ansi[136] = [[ê]]
ansi[137] = [[ë]]
ansi[138] = [[è]]
ansi[139] = [[ï]]
ansi[140] = [[î]]
ansi[141] = [[ì]]
ansi[142] = [[Ä]]
ansi[143] = [[Å]]
ansi[144] = [[É]]
ansi[145] = [[æ]]
ansi[146] = [[Æ]]
ansi[147] = [[ô]]
ansi[148] = [[ö]]
ansi[149] = [[ò]]
ansi[150] = [[û]]
ansi[151] = [[ù]]
ansi[152] = [[ÿ]]
ansi[153] = [[Ö]]
ansi[154] = [[Ü]]
ansi[155] = [[¢]]
ansi[156] = [[£]]
ansi[157] = [[¥]]
ansi[158] = [[₧]]
ansi[159] = [[ƒ]]
ansi[160] = [[á]]
ansi[161] = [[í]]
ansi[162] = [[ó]]
ansi[163] = [[ú]]
ansi[164] = [[ñ]]
ansi[165] = [[Ñ]]
ansi[166] = [[ª]]
ansi[167] = [[º]]
ansi[168] = [[¿]]
ansi[169] = [[⌐]]
ansi[170] = [[¬]]
ansi[171] = [[½]]
ansi[172] = [[¼]]
ansi[173] = [[¡]]
ansi[174] = [[«]]
ansi[175] = [[»]]
ansi[176] = [[░]]
ansi[177] = [[▒]]
ansi[178] = [[▓]]   --exceptions[178] = true
ansi[179] = [[│]]
ansi[180] = [[┤]]
ansi[181] = [[╡]]
ansi[182] = [[╢]]
ansi[183] = [[╖]]
ansi[184] = [[╕]]
ansi[185] = [[╣]]
ansi[186] = [[║]]
ansi[187] = [[╗]]
ansi[188] = [[╝]]
ansi[189] = [[╜]]
ansi[190] = [[╛]]
ansi[191] = [[┐]]
ansi[192] = [[└]]
ansi[193] = [[┴]]
ansi[194] = [[┬]]
ansi[195] = [[├]]
ansi[196] = [[─]]
ansi[197] = [[┼]]
ansi[198] = [[╞]]
ansi[199] = [[╟]]
ansi[200] = [[╚]]
ansi[201] = [[╔]]
ansi[202] = [[╩]]
ansi[203] = [[╦]]
ansi[204] = [[╠]]
ansi[205] = [[═]]
ansi[206] = [[╬]]
ansi[207] = [[╧]]
ansi[208] = [[╨]]
ansi[209] = [[╤]]
ansi[210] = [[╥]]
ansi[211] = [[╙]]
ansi[212] = [[╘]]
ansi[213] = [[╒]]
ansi[214] = [[╓]]
ansi[215] = [[╫]]
ansi[216] = [[╪]]
ansi[217] = [[┘]]
ansi[218] = [[┌]]
ansi[219] = [[█]]   --exceptions[219] = true
ansi[220] = [[▄]]   exceptions[220] = true
ansi[221] = [[▌]]   exceptions[221] = true
ansi[222] = [[▐]]   exceptions[222] = true
ansi[223] = [[▀]]   exceptions[223] = true
ansi[224] = [[α]]
ansi[225] = [[ß]]
ansi[226] = [[Γ]]
ansi[227] = [[π]]
ansi[228] = [[Σ]]
ansi[229] = [[σ]]
ansi[230] = [[µ]]
ansi[231] = [[τ]]
ansi[232] = [[Φ]]   exceptions[232] = true
ansi[233] = [[Θ]]   exceptions[233] = true
ansi[234] = [[Ω]]
ansi[235] = [[δ]]   exceptions[235] = true
ansi[236] = [[∞]]
ansi[237] = [[φ]]   exceptions[237] = true
ansi[238] = [[ε]]
ansi[239] = [[∩]]
ansi[240] = [[≡]]
ansi[241] = [[±]]
ansi[242] = [[≥]]
ansi[243] = [[≤]]
ansi[244] = [[⌠]]
ansi[245] = [[⌡]]
ansi[246] = [[÷]]
ansi[247] = [[≈]]
ansi[248] = [[°]]
ansi[249] = [[∙]]
ansi[250] = [[·]]
ansi[251] = [[√]]
ansi[252] = [[ⁿ]]
ansi[253] = [[²]]
ansi[254] = [[■]]   exceptions[254] = true
ansi[255] = [[ ]]


--# Proc
fdata = {}
fpos = 32

SCALE=1

fsize = {}
fsize.h = 12*SCALE     -- height
fsize.xh = 7*SCALE     -- x-height
fsize.desc = 4*SCALE   -- descent
fsize.fh = fsize.h + fsize.desc

fsize.w = 8*SCALE

TYPES = 8

gs = 40

function dataString(a)
    local s = "{\n"
    for i, v in pairs(a) do
        s = s .. " [" .. i .. "]={\n"
        --setWidth(i)
        for ri, row in ipairs(v) do
            s = s .. "  [" .. ri .. "]={"
            --local row = v[ri]
            for ci = 1, uiWidth do
                s = s .. row[ci] .. ","
            end
            s = s .. "},\n"
        end
        s = s .. " },\n"
    end
    return s .. "}"
end

--# UI
function range(n, x, y, n2, x2, y2)
    return n > x and n < y and (n2 and (n2 > x2 and n2 < y2) or not(n2))
end

function bounds(n, a, b)
    return math.max(a, math.min(b, n))
end

uiWidth = fsize.w
pWidth = fsize.w

function setWidth(c)
    --uiWidth = 1
    for i, v in ipairs(fdata[c]) do
        local ii = 1
        while ii < math.max(#v, math.max(pWidth, uiWidth)+1) + 1 do
            if v[ii] and v[ii] > 0 then
                uiWidth = math.max(uiWidth, ii + 1)
            end
            ii = ii + 1
        end
    end
    uiWidth = fsize.w
end

function setChar(c)
    --c = c % 255
    fpos = c
    if fdata[c] and #(fdata[c]) == fsize.fh then
        --setWidth(c)
    else
        fdata[c] = fdata[c] or {}
        for n = 1, fsize.fh do
            if not fdata[c][n] then fdata[c][n] = {0, 0} end
        end
        --setWidth(c)
    end
    saveProjectData("CurrentChar", c)
    for y, r in ipairs(fdata[c]) do
        for x, c in ipairs(r) do
            if c > 0 then print(x, y) return end
        end
    end
    local i = image(fsize.w, fsize.fh)
    setContext(i)
    fill(255)
    stroke(255)
    font("Inconsolata")
    fontSize(fsize.fh+2)
    textMode(CORNER)
    text(ansi[c%255] or string.char(c%255), -1,0)
    setContext()
    for y, r in ipairs(fdata[c]) do
        for x, col in ipairs(r) do
            local r,g,b,a=i:get(x, y)
            --if a > 0 then print(a, x, y) end
            if a == 0 then fdata[c][y][x] = 0 end
        end
    end
end

function drawUI()
    rectMode(CORNER)
    noSmooth()
    strokeWidth(1)
    stroke(0)
    textMode(CORNER)
    fontSize(12)
    local mx, my = 0, 0
    local i = image(uiWidth+1, fsize.fh)
    setContext(i)
    background(255)
    setContext()
    spriteMode(CORNER)
    for y, r in ipairs(fdata[fpos]) do
        my = math.max(my, y * gs + gs)
        for x = 1, uiWidth do
            local c = r[x]
            if range(CurrentTouch.x, x*gs, x*gs+gs) and range(CurrentTouch.y, y*gs, y*gs + gs) then
                if CurrentTouch.state < ENDED then
                    fill(150)
                elseif not ctended then
                    fdata[fpos][y][x] = ((fdata[fpos][y][x] or 0) + 1) % 2
                    setContext(F_IM)
                    pushStyle()
                    fill(0, fdata[fpos][y][x]*255)
                    noSmooth()
                    noStroke()
                    blendMode(ONE, ZERO)
                    rect(((fpos*fsize.w+x)%(255*fsize.w))*.5-.5, ((y-1)+(math.floor(fpos/255)*fsize.fh))*.5, .5, .5)
                    setContext()
                    --saveImage(fRaw, F_IM)
                    popStyle()
                    fill(0)
                    ctended = true
                elseif c > 0 then
                    fill(0)
                else
                    fill(255)
                end
                --setWidth(fpos)
            elseif c and c > 0 then
                fill(0)
            else
                fill(255)
            end
            if fill() < 200 then
                i:set(x, y, color(fill()))
            end
            if y > fsize.desc and y <= fsize.xh + fsize.desc then
                strokeWidth(1.5)
            elseif y > fsize.xh + fsize.desc then
                strokeWidth(1)
            else
                strokeWidth(.5)
            end
            rect(x * gs, y * gs, gs+5, gs+5)
            mx = math.max(mx, x*gs + gs)
        end
    end
    fill(0)
    text("Character: " .. (ansi[fpos%255] or string.char(fpos%255) or "") .. " (" .. fpos .. ")", gs, my + 5)
    sprite(i, mx + 10, my - fsize.fh)
    
    --[[
    fontSize(fsize.fh/2)-- * gs)
    scale(gs*2)
    fill(128, 50)
    text(string.char(fpos), 0.,.5)--gs, gs)
    --]]
    --[[
    fontSize(fsize.fh * gs)
    fill(128, 25)
    text(string.char(fpos), gs*0, gs+23)
    --]]
end

--# Render

--# utf8
--[[
🯐
]]
--# Rose
Rose = class()
function Rose:init(a, b)
    a = a or 100
    b = b or 3
    local rose = function(angle) 
        return a * math.cos(b * angle) 
    end
    self.points = {}
    for theta = 0, math.pi * 2, 0.04 do
        local r = rose(theta)
        local x, y = r * math.cos(theta), r * math.sin(theta)
        table.insert(self.points, vec2(x, y))
    end
    self.factor = #self.points-1-80
    self.colors = {color(255, 0, 0, 255),color(255, 118, 0, 255),
    color(255, 230, 0, 255),color(73, 255, 0, 255),
    color(0, 249, 255, 255),color(15, 0, 255, 255),
    color(190, 0, 255, 255),color(255, 0, 172, 255)}
    self.next = 3
end
function Rose:draw()
    self:ccyc(true)
    for i = 80, #self.points - 1 do
        --[[
        stroke(self:ccyc())
        --[=[
        --]]
        stroke(0)
        --stroke((i-80)/(#self.points-80)*255)
        --]=]
        strokeWidth(8-7*(i-80)/self.factor)
        line(self.points[i].x, self.points[i].y, self.points[i + 1].x, self.points[i + 1].y)
    end
    local last = self.points[#self.points]
    for i = #self.points, 2, -1 do
        self.points[i] = self.points[i - 1]
    end
    self.points[1] = last
end
function Rose:ccyc(reset)
    if reset then
        self.num = 0
        self.c2 = self.colors[2]
        self.c1 = self.colors[1]
        self.next = 3
        self.gl = 0
    else
        self.num = self.num + 1/self.factor
        if self.num*7>=1 then
            self.c1 = self.c2
            self.c2 = self.colors[self.next] or self.colors[1]
            self.num = 0
            self.next = self.next + 1 
        end
        return self.c2:mix(self.c1,self.num*7)
    end
end

--# Compress
function compressFont(testing)
    local i = image(255*TYPES,6)
    i.premultiplied = false
    for c = 1, 255*TYPES - 2 do
        local rows = {}
        for y = 1, #fdata[c] do
            rows[y] = {}
            for x = 1, 8 do
                rows[y][x] = fdata[c][y][x] > 0 and 1 or 0
                --if not rows[y][x] then error(c .. "," .. x .. ',' .. y) end
            end
        end
        for n = 1, 16, 3 do
            --local r,g,b,a=0,0,0,0
            local col = color(0,0,0)
            for x = 1, 8 do
                --if not rows[n] then print("No " .. n) elseif not rows[n][x] then print("No " .. n .. "," .. x) end
                --[=[
                if rows[n][x] == 1 then col.r = col.r + (1 << (x-1)) end
                if rows[n][x+1] == 1 then col.g = col.g + (1 << (x-1)) end
                if rows[n][x+2] == 1 then col.b = col.b + (1 << (x-1)) end
                if rows[n][x+3] == 1 then col.a = col.a + (1 << (x-1)) end
                --[[
                --]=]
                col.r = col.r | (rows[n][x]<<(x-1))
                if n < 15 then
                    col.g = col.g | (rows[n+1][x]<<(x-1))
                    if n < 15 then
                        col.b = col.b | (rows[n+2][x]<<(x-1))
                    end
                end
                --col.a = col.a | (rows[n+3][x]<<(x-1))
                --]]
            end
            i:set(c, math.ceil(n/3),
            testing and color(c+n,c+n+1,c+n+2,c+n+3) or col
            )
        end
    end
    i.premultiplied = false
    return i
end
