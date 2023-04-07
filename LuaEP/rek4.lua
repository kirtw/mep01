local LuaRekRunning = "rek4.lua"

-- Copyright: Consider this file public domain.  Attribution would be
-- nice, though not required.

-- Usage: just execute `lua recogniser.lua` in the command line.
-- You probably want to tinker with the grammar and the input at the
-- end of this file.

-- Prerequisites: imperative programming and basic knowledge of Earley
-- parsing. The tutorial at
--   <http://loup-vaillant.fr/tutorials/earley-parsing/>
-- is highly recomended.
-- You don't need to know Lua.  Think of it as "executable pseudocode".

--********** kw move code ?

--**********
---------------------
-- Data Structures --
---------------------

-- Earley items are basically 3 integers.  I have represented them
-- with Lua tables:
local earley_item = {
   rule  = index_of_rule_in_grammar,
   next  = index_of_symbol_in_rule,
   start = start_position_in_input,
}
-- There are cleverer representation.  This one is merely the dumbest
-- I came up with.

-- Earley sets are dynamic arrays of Earley items.  They are
-- represented with Lua tables.  Warning: In Lua, array indices start
-- at 1.
-- S is the whole state of an Earley parsing.  It's a dynamic array of
-- Earley sets.  Again, they are represented with Lua tables.

-- Non-terminal symbols are represented with strings.
-- Terminal symbols are represented with functions:
local function  char(...) return ... end
local function class(...) return ... end
local function range(...) return ... end

-- Rules are Lua tables. Note: unnamed elements are implicitely
-- numbered.  That helps to represent arrays.  Warning: Lua arrays
-- start at 1.
-- So, the following lines represent the same rule:
local my_rule = { name = 'Sum',       'Sum',       class('+-'),       'Product'}
local my_rule = { name = 'Sum', [1] = 'Sum', [2] = class('+-'), [3] = 'Product'}

-- Grammars are a list of rules, and a name for the start rule.  They
-- are represented with...  Lua tables.  again, notice the unnamed
-- elements.
local example_grammar = {
   start_rule_name = 'Sum',
   { name = 'Sum'    , 'Sum'      , class('+-'), 'Product'},
   { name = 'Sum'    , 'Product'  ,                       },
   { name = 'Product', 'Product'  , class('*/'), 'Factor' },
   { name = 'Product', 'Factor'   ,                       },
   { name = 'Factor' , char('(')  , 'Sum', char(')')      },
   { name = 'Factor' , 'Number'                           },
   { name = 'Number' , range('09'), 'Number'              },
   { name = 'Number' , range('09'),                       },
}

-- (note: all the code above is dead. The real deal starts now.)


--------------------
-- Test utilities --  (Don't read this yet, it's not very interesting.)
--------------------

function has_partial_parse(S, i, grammar)
   local set = S[i]
   for i = 1, #set do
      local item = set[i]
      local rule  = grammar[item.rule]
      if rule.name  == grammar.start_rule_name and
         item.next  >  #rule                   and
         item.start == 1
      then
         return true
      end
   end
   return false
end

function has_complete_parse(S, grammar)
   return has_partial_parse(S, #S, grammar)
end

function last_partial_parse(S, grammar)
   for i = #S, 1, -1 do
      if has_partial_parse(S, i, grammar) then
         return i
      end
   end
   return nil
end

function diagnose(S, grammar, input)
   if has_complete_parse(S, grammar)
   then
      print("The input has been recognised. Congratulations!")
   else
      io.write("dx failed test ",#S," vs inlut:len()-",input:len(),"  +1","\n")
      if #S == input:len() + 1
      then print("The whole input made sense. Maybe it is incomplete?")
      else io.write("The input stopped making sense at character ", #S, '\n')
      end

      local lpp = last_partial_parse(S, grammar)
      if lpp ~= nil
      then io.write("This begining of the input has been recognised: ",
                    input:sub(1, lpp - 1), '\n')
      else print("The begining of the input couldn't be parsed.")
      end
   end
end

---------------
-- Utilities -- (Read the function names and the comments.)
---------------
local function termMch(inputArg,Si,tok)
    inC = string.sub(inputArg,Si,Si)
    io.write("MCH test ",inC,"\n")
    return false
end
    
-- * * NEXT_SYMBOL  - TokR1 (str or function char, class, range -   
-- next_symbol --> getTokR1(item,grammar)
local function getTokR1(item,grammar,trc)
    if type(trc) ~= 'string' then trc="trc?" end
    local gsi = item.rule
    local tdot = item.next
             pdump("gTok",item)
             if type(item) == 'table' then io.write("gTok item table ",trc,"  ",dump(item),"\n")  end
             if type(tdot) ~= 'number' then io.write("gTok tdot ",trc," ty tdot: ",type(tdot),"  ","\n item= ",dump(item),"\n")  end
    local fdot = item.next + 1
    local TokR1 = grammar[gsi][fdot]
-- nil => complete, No longer functions
    io.write("TokR1:",TokR1,"\n")
    return TokR1
end                                       
                    
-- next element in the rule of this item
local function next_symbol(grammar, item)
    local fgsi = item.rule
    local fdot = item.next
    local grul = grammar[fgsi]
    local fnx = grul[fdot]
    local nxSym = grammar[item.rule][item.next]   
--    io.write("type of nxSym:",type(nxSym),"\n")     
--    io.write("type of grul:",type(grul),"\n")     
--    io.write("type of fnx:",type(fnx),"\n")    
--    io.write("type of grammar:",type(grammar),"\n")
--    io.write("type of grammar[][]:",type(grammar[item.rule][item.next]),"\n")    
    if nxSym ~= fnx then 
       io.write("Err nxSymFn ",fnx," '= ",nxSym,"\n")
       end
    if type(nxSym) == 'string' then
       io.write("nxSymFn- Get TokR1 :",nxSym,"  \n")
    else
       io.write("nxSymFn- TokR1 is terminal function","\n")
       end
   return grammar[item.rule][item.next]
end

-- gets the name of the rule pointed by the item
local function name(grammar, item)
   return grammar[item.rule].name
end

-- compares two items for equality (needed for safe append)
local function equal(item1, item2)
   if type(item1)=='Nil' then return false end
   return item1.rule  == item2.rule
      and item1.start == item2.start
      and item1.next  == item2.next
end

-- Adds an item at the end of the Earley set
-- set is a list of Si vals, ?? integer ~ Si, item is obj/array  
--  Call by ref  - updated, ?global scope vs arg ?
-- both key/val name and indexed [1:1] tokens in list, SIC!kw
local function unsafe_append(set, item)
   set[#set+1] = item
end

-- Adds an item at the end of the Earley set, **unless already present**
-- * * SSC
local function SSC(S,Si,Sj,SVi,itemSV,trc)
    local SVj 
    local item
    for SVj=1, #S[Si] do
       item = S[SVi][SVj]
       if item ~= 'nil' and
         equal(item,itemSV) then  return
    end
    SVj = #S[SVi] + 1                       
    S[SVi][SVj] = itemSV
--                            
    local Sij = "["..Si.."."..Sj.."] "
    local SVij = "["..SVi ..".".. SVj.."] "
    local itemS = SVij..itemSV.rule.."_"..itemSV.next.."_"..itemSV.start                            
    io.write("SSC APD  ",itemS,"  by ",trc,"\n")                           
end   
end
-- * * APPEND * *                            
local function append(set, item,trc)
-- sic i is GLOBAL here ! -> gqi really local here
   local gqi
   local Sj                            
   for gqi = 1, #set do  
      if equal(item, set[gqi]) then
--       io.write("Appnd Dupl rej:",item.rule,"  set-item",set[gqi].rule,"\n")
         return
      end
   end
   Sj=#set + 1                            
   set[Sj] = item   
   io.write("APnd Add ",Si,".",Sj,"]  gsi:",item.name,",  dot:",item.next,", inPst:",item.start,"  by  ",trc,"\n")                            
--   unsafe_append(set, item) -- the item wasn't already there, we add it
end

---------------------------  ---------------------------  ----------------
-- Building Earley items --  This is the core algorithm.  Read everything.
---------------------------  ---------------------------  ----------------
-- rule S[i,j] ie item just passed, input moved dot to far right.
--
--                    * * * COMPLETE * * *
local function complete(S, Si, Sj, grammar)
   local item = S[Si][Sj]
   local old_item_index, old_item
     local Cst = item.start
     local Cend = Si
     local Cdot = item.next
     local Cgsi = item.rule
   io.write("Complete item loops thru S[",item.start,"] ",item.rule," ",item.next)
   local Cset = S[item.start]
   for old_item_index, old_item in ipairs(S[item.start]) do
      io.write("item all tok done, Complete loop-",Si,".",Sj,"  old:",old_item_index,"<>",type(old_item),"\n")
      local TokR1= getTokR1(grammar, old_item,Si.."."..Sj.." C") 
 --     tokVal= symbol(grammar, old_item)  io.write("\n tokVal:",tokVal)
      local ngri= name(grammar, item)
      io.write("\n Test getTokR1:",type(tokr1)," ?== ",ngri," : name(gram... ")
--      TokR1 = getTokR1(grammar,old_item,"OLD-C")
      if TokR1 == name(grammar, item) then
         local newItem = item
         newItem.next = item.next + 1
--         append(S[Si],newItem,"COMP")
         SSC(S,Si,Sj,Si+1,newItem,"COMP")
--         append(S[Si], { rule  = old_item.rule,
--                        next  = old_item.next + 1,
--                        start = old_item.start },"COMP")            
      end
   end
end
--                     * * * SCAN * * *
local function scan(S, Si, Sj, symbol, inputarg)
   local item = S[Si][Sj]
   if termMch(inputarg, Si) then -- terminal symbols are predicates
      if S[Si+1] == nil then S[Si+1]  = {} end
-- update terminal match item?              
   local itemSV = item
     itemSV.next = item.next + 1
   SSC(S,Si,Sj,Si+1,itemSV,"SCAN")
--    append(S[Si+1], { rule  = item.rule, next  = item.next + 1, start = item.start })
--  io.write(" * Scan mch:", Si,".",Sj," sym:",inputarg,"  ", type(symbol),"  in:",type(input),"  new item:",i+1,"-","  dot/nx:",1,"\n")
              
end
end
--                  * * * PREDICT * * *
local function predict(S, Si, symbol, grammar)
       io.write("!  PRED sym:",symbol,"\n")
   for gqi, rule in ipairs(grammar) do
-- io.write("Pred test sym:", symbol,"   ru-name:", rule.name, "\n")
      if rule.name == symbol then
         pdump("PR ",rule)
         SSC(S,Si,Sj,Si,rule,"PRED")
--         append(S[Si], { rule  = rule_index,
--                        next  = 1 ,
--                        start = i },"PRED")
        io.write("Pred mch:", i, "  ", symbol,"  new item:",i,"-"," grx:",rule_index,"  dot/nx:",1,"\n")  -- ,next/dot is 1
      end
   end
end
--------
local function initS(S,grammar)
    local gsi,itemSV, Sj=0
    local  setT = S[1]
    for gsi = 1, #Bgram do
       io.write("Try init ",gsi,"  ",Bgram[gsi].name,"\n")
      if Bgram[gsi].name == Bgram.start_rule_name then
           Sj = Sj + 1
           itemSV = { rule  = gsi, start = 1, next  = 1 }
           setT[Sj] = itemSV
           io.write("Init:",type(setT[Sj])," Sj=",Sj,"\n")   
       end  -- end if-then
   end  -- end for/do
end       
--           * * * * *  BUILD * * * * *
local function build_items(Bgram, input)
   -- Earley sets
   local S = {{}}
   -- put start item(s) in S[1]
   S[1][1] = { rule  = 1, start = 1, next  = 1 }
   S[1][2] = { rule  = 2, start = 1, next  = 1 }
   print(S[1][2])
--   S=1
   io.write(" Init S -","\n")
   print_Sec(S, 1, Bgram)
   pdump("Init S \n",S)
   -- populate the rest of S[i]
   local Si = 1
   while Si <= #S do
      local Sj = 1
      while Sj <= #S[Si] do
         local stat = " $$ "..Si.."."..Sj.." "
         local itemX = S[Si][Sj]
         pdump(stat.." itemX",itemX)
         if type(itemX) == 'nil' then io.write(" !!! B2lp nil ",Si,".",Sj,"\n")  end 
         if type(itemX) == 'table' then io.write("B2lp table ",Si,".",Sj,"  ",itemX.rule,"  dot:",itemX.next,"\n")  end
         local symbol = getTokR1(Bgram, itemX,"B2-X")
         io.write("B2lp ",Si,".",Sj,"  type(sym:",type(symbol),"\n")
         if     type(symbol) == "nil"  then complete(S, Si, Sj, grammar)
         elseif type(symbol) == "function"        then error("illegal rule function") return
         elseif type(symbol) ~= "string"          then error("illegal rule")  return
         elseif symbol.byte(1) == 'C' then  predict(S, Si,    symbol, grammar)
         else                          scan(S, i, j, symbol, input)
         end
         Sj = Sj + 1
      end
      Si = Si + 1
      io.write(" end Outer B-loop:",Si," ","\n")  --   symbol,
   end
   return S
end

--------------
-- Printing -- (Don't read this yet, it's just utility code.)
--------------

-- Object that prints nicely laid out columns.
--
-- Usage:
--   pp = pretty_printer()
--   pp.line()
--     pp.col() pp.write('a', 42)
--     pp.col() pp.write(' |')
--   pp.line()
--     pp.col() pp.write("something") pp.write(" longer")
--     pp.col() pp.write(' |')
--     pp.col() pp.write(' another column')
--   pp.print()
--
-- result:
--   a42              |
--   something longer | another column
local function pretty_printer()
   local self = {}

   function self.write(...)
      local args = {...}
      for _, v in ipairs(args) do
         local l = self[#self] -- current line
         l[#l] = l[#l]..tostring(v)
      end
   end

   function self.col()
      local l = self[#self] -- current line
      l[#l+1] = ""
   end

   function self.line()
      self[#self+1] = {}
   end

   local function max(f)
      local m = 0
      for _, v in ipairs(self) do
         local x = f(v)
         if x > m then m = x end
      end
      return m
   end

   local function len(i)
      return function(v)
         if v[i] == nil
         then return 0
         else return v[i]:len()
         end
      end
   end

   local function nb_col(line) return #line end

   function self.print(indent)
      if indent == nil then indent = 0 end
      for i = 1, max(nb_col) do
         local max_len = max(len(i))
         for _, line in ipairs(self) do
            if line[i] == nil then line[i] = "" end
            line[i] = line[i]..string.rep(" ", max_len - line[i]:len())
         end
      end
      for _, line in ipairs(self) do
         io.write(string.rep(" ", indent))
         for _, col in ipairs(line) do
            io.write(col)
         end
         io.write('\n')
      end
   end

   return self
end
-- Print Section
-- dump a table, one level rets string
function pdump(M,o)
   if type(M) ~= 'string' then M="p dump- \n" end
   io.write(M," ",dump(o),"\n\n")
end
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end
-- Prints one section, Si, of S
function print_Sec(S, Si, grammar)
     local set = S[Si]
      io.write('    === ', Si-1, ' ===  #set:',type(set),"/",#set,'\n')
      pp = pretty_printer()
      for j, st in ipairs(set) do
         pp.line()
         pp.col() pp.write(name(grammar, st))
         pp.col() pp.write(' ->')
         for k, symbol in ipairs(grammar[st.rule]) do
            if k == st.next                   then pp.write(' •') end
            if     type(symbol) == "string"   then pp.write(' ', symbol)
            elseif type(symbol) == "function" then pp.write(' ', symbol())
            else                                   error("Impossible symbol")
            end
         end
         if st.next > #grammar[st.rule] then pp.write(' •') end
         pp.col() pp.write('  (', st.start-1, ')')
      end
      pp.print(4)
      io.write('\n')
   end
-- Prints all the Earley items.
local function print_S(S, grammar)
   for i, set in ipairs(S) do
      io.write('    === ', i-1, ' ===\n')
      pp = pretty_printer()
      for j, st in ipairs(set) do
         pp.line()
         pp.col() pp.write(name(grammar, st))
         pp.col() pp.write(' ->')
         for k, symbol in ipairs(grammar[st.rule]) do
            if k == st.next                   then pp.write(' •') end
            if     type(symbol) == "string"   then pp.write(' ', symbol)
            elseif type(symbol) == "function" then pp.write(' ', symbol())
            else                                   error("Impossible symbol")
            end
         end
         if st.next > #grammar[st.rule] then pp.write(' •') end
         pp.col() pp.write('  (', st.start-1, ')')
      end
      pp.print(4)
      io.write('\n')
   end
end


           
--------------------------------
-- Terminal symbol generators -- Do read this, but don't try too hard.
-------------------------------- There are less clever ways to do this.

-- The following functions generate terminal symbols.  A terminal
-- symbol is a function that tell us if the input matches them:
--    local semicolon = char(';')
--    print(semicolon(';')) -- true
--    print(semicolon('x')) -- false
--
-- They also come with an ugly hack to help us print them nicely:
--    print(semicolon()) -- ';'

local function char(c)
   return function(input, inPtr)
      if input == nil
      then return "'"..c.."'" -- ugly hack used to print items
      else return input:byte(inPtr) == c:byte()
      end
   end
end

local function range(r)
   return function(input, inPtr)
      if input == nil
      then return "["..r:sub(1, 1)..'-'
                     ..r:sub(2, 2).."]" -- ugly hack used to print items
      else
         local i = input:byte(inPtr)
         return i ~= nil
            and i >= r:byte(1)
            and i <= r:byte(2)
      end
   end
end

local function class(c)
   return function(input, inPtr)
      if input == nil
      then return "["..c:sub(1, 1)
                     ..c:sub(2, 2).."]" -- ugly hack used to print items
      else
         return inPtr <= input:len()
            and c:find(input:sub(inPtr, inPtr), 1, true) ~= nil
      end
   end
end

-------------------
-- Hello, world! --
-------------------


local Grammar = {
   start_rule_name = 'Sum',
   { name = 'Sum'    , 'Sum'      , 'Csum+', 'Product'},
   { name = 'Sum'    , 'Product'  ,                       },
   { name = 'Product', 'Product'  , 'Cprod+', 'Factor'    },
   { name = 'Product', 'Factor'   ,                       },
   { name = 'Factor' , 'Cop+'  , 'Sum', 'Ccp+'         },
   { name = 'Factor' , 'Number'                           },
   { name = 'Number' , 'Cdig', 'Number'              },
   { name = 'Number' , 'Cdig',                       },
}
local input = "1+(2*3+4)" -- Tinker with this first.
                          -- I have left some examples.
-- local input = "@@(2*3+4)"
-- local input = "1+(2*@@@@"
-- local input = "1+(2*"
-- local input = "1+(2*3+4)"
local S = build_items(Grammar, input)

io.write("Input: ", input, '\n') -- print the input
io.write("input is of Lua type:",type(input),"\n")
io.write("Grammar is of Lua type:",type(Grammar),"\n")
io.write("S two levels is Lua type:",type(S),"\n")

print_S(S, Grammar)              -- print all the internal state

diagnose(S, Grammar, input)      -- tell if the input is OK or not

