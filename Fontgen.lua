
--# ansi
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


--# Main
-- TermChars

-- Use this function to perform your initial setup
function setup()

    local s = 16
    local w = s/2
    cfont = "Inconsolata"
    
    chr = image(w*255, (s)*8)
    
    stroke(255)
    fill(255)
    textMode(CORNER)
    font(cfont)
    fontSize(s+1)
    for c = 33, 254 do
        fill(255)
        local char = utf8.char(c)
        clip(c*w, 0, w, s)
        setContext(chr)
        --background(0)
        text(char or string.char(c), c*w, 1)
        setContext()
        if c % 25 == 0 then
            print(c)
        end
    end    
    
    saveImage("Documents:char", chr)
    print"Done"

end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    spriteMode(CORNER)
    -- Do your drawing here
    sprite(chr, 0,0)
end
