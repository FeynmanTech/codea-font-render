
--# Main
-- Font Designer

-- Use this function to perform your initial setup
function setup()
    socket = require"socket"
    noSmooth()
    scc = {}
    fdata = {}
    local i = readImage("Documents:RASTER_FONT")
    if i then
        local i2 = image(i.width*2,i.height*2)
        print("Images made")
        spriteMode(CORNER)
        noSmooth()
        setContext(i2)
        sprite(i,0,0,i.width*2, i.height*2)
        setContext()
        print("Sprites made")
        --local s = "--[["
        for c = 1, i2.width*TYPES-fsize.w, fsize.w do
            fdata[(c-1)/fsize.w] = {}
            for y = 1, fsize.fh do
                fdata[(c-1)/fsize.w][y] = {}
                for x = 0, fsize.w-1 do
                    local r,g,b,a = i2:get(c%i2.width+x, y+math.floor(c/i2.width)*fsize.fh)
                    --s = s .. a
                    fdata[(c-1)/fsize.w][y][x] = a>0 and 1 or 0
                end
            end
        end
        print("Scanned")
    end
    setChar(readProjectData("CurrentChar") or ("A"):byte())
    spriteMode(CORNER)
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(255, 255, 255, 255)

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
end

function touched(touch)
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
            local i = image((255) * fsize.w*.5, (fsize.h+fsize.desc)*.5*TYPES)
            setContext(i)
            noStroke()
            noSmooth()
            fill(0)
            for c, char in pairs(fdata) do
                for y, row in ipairs(char) do
                    for x, col in ipairs(row) do
                        if col == 1 then
                            rect(((c*fsize.w+x)%(255*fsize.w))*.5, ((y-1)+(math.floor(c/255)*fsize.fh))*.5, .5, .5)
                        end
                    end
                end
            end
            saveImage("Documents:RASTER_FONT", i)
            print("Saved ("..(socket.gettime() - time)..")")
            time = socket.gettime()
            local ci = image(255*TYPES-fsize.w, fsize.fh/4)
            
            local format = {"r", "g", "b", "a"}
            local bl = {}
            for c = 1, 255*TYPES-fsize.w do
                for block = 0, 3 do
                    local col = color(0,0)
                    for y = 1, 4 do
                        for x = 0, fsize.w-1 do
                            if fdata[c] and fdata[c][block*4+y] then
                                col[format[y]] = col[format[y]] + fdata[c][block*4+y][x] * (2^x)
                            end
                        end
                    end
                    ci:set(c, block+1, col)
                end
            end
            saveImage("Documents:RASTER_FONT_COMPRESSED", ci) -- not functional yet
            print("Compressed ("..(socket.gettime() - time)..")")
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
ansi[93] = "]"
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
        for ri, row in ipairs(v) do
            s = s .. "  [" .. ri .. "]={"
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

function setWidth(c) -- unused
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
    fpos = c
    if not(fdata[c]) or #(fdata[c]) ~= fsize.fh then
        fdata[c] = fdata[c] or {}
        for n = 1, fsize.fh do
            if not fdata[c][n] then fdata[c][n] = {0, 0} end
        end
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
                    if fdata[fpos][y][x] < 1 then
                        pWidth = uiWidth
                        uiWidth = 1
                    end
                    fill(80)
                    ctended = true
                elseif c > 0 then
                    fill(80)
                else
                    fill(255)
                end
                setWidth(fpos)
            elseif c and c > 0 then
                fill(80)
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
end
