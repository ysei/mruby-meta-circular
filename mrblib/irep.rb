
module RiteOpcodeUtil

  # $pltini = Proc.new {
  def plini

    @pl[0] = ['th', 'sym', '_sp', 'ctr']
    @pl[1] = [false,   0,     0,     0 ]
    @pl0 = @pl[0]
    @pl1 = @pl[1]

#   (1..$pcmax + 1).each{ |n| @pl[n] = Envha.new(n, {})}
#     @pl = [$pcmax + 1, {}]
#     @envid = @pl.gethd

#     @@wa.each{ |v|
#     @@idx[v] = wa.index(v)
##    eval "v = wa.index(v)"
#   }

#   @idx = Hash.new
#   for n in (0 ... pl0.size)
#      key = pl0[n]
#      @idx[key] = n
#   end
  end

  def wkth(pc = 1)
#    Thread.new($pcmax) { |pcmax|
    Thread.new(pc) { |pc|
      ENVary.new(0).plw(pc)
    }
  end

  def get_opcode(op)
    op & 0x7f
  end

  def getarg_a(op)
    (op >> 23) & 0x1ff
  end
#  $getarg_a = Proc.new { |op|
#    Thread.new {
#      while ! @pl[ @pc - 1 ][ 'dn' ] do
#       op = @pl[ @pc - 1 ][ 'th' ]
#      end
#      @stack[ sp + getarg_a(cop)] = (op >> 23) & 0x1ff
#      while ! @pl[@pc][ 'dn' ] do
#       op = @pl[@pc][ 'th' ]
#      end
#    }
#  }

  def getarg_b(op)
    (op >> 14) & 0x1ff
  end

  def getarg_c(op)
    (op >> 7) & 0x7f
  end

  def getarg_bx(op)
    (op >> 7) & 0xffff
  end

  def getarg_sbx(op)
    ((op >> 7) & 0xffff) - (0xffff >> 1)
  end

  def mk_opcode(op)
    op & 0x7f
  end

  def mkarg_a(op)
    (op & 0x1ff) << 23
  end

  def mkarg_b(op)
    (op & 0x1ff) << 14
  end

  def mkarg_c(op)
    (op & 0x7f) << 7
  end

  def mkarg_bx(op)
    (op & 0xffff) << 7
  end

  def mkarg_sbx(op)
    mkarg_bx(op + (0xffff >> 1))
  end

  def mkop_A(op, a)
    (mk_opcode(op) | mkarg_a(a))
  end

  def mkop_AB(op, a, b)
    (mkop_A(op, a) | mkarg_b(b))
  end

  def mkop_ABC(op, a, b, c)
    (mkop_AB(op, a, b) | mkarg_c(c))
  end

  def mkop_ABx(op, a, b)
    (mkop_A(op, a) | mkarg_bx(b))
  end

  def mkop_AsBx(op, a, b)
    (mkop_A(op, a) | mkarg_sbx(b))
  end
end

class RiteVM
  include RiteOpcodeUtil

  def initialize
    @stack = []
    @callinfo = []
    @pc = 0
    @sp = 0
    @bp = 0
    @cp = 0

#    rmth = 63
#    rmth = 47
    rmth = 39
#    @pla = Array.new($pcmax)
#   $pltini.call()
#    @pl = ENVary.new((rmth + 1) << 1, [['~~', 0]])
#    @pl = ENVary.new((rmth + 1) << 1, [[[], 0]])
    @pl = ENVary.new((rmth + 1) << 1, [[false, 0]])

    plini
#    @pl.idx_s

    @idx = Hash.new
    pl0 = @pl0
    for n in (0 ... pl0.size)
      k = pl0[n]
      @idx[k] = n
    end

    @rmt = wkth
#    GC.disable

#   5ff9c1d2 :
#   Assertion failed: ((obj)->tt != MRB_TT_FREE), function mrb_gc_mark, file src/gc.c, line 577.

#   ysei/mruby-thread/tree/normal/ 4c02f126
#       / mruby-thread/crimsonwoods/tree/experimental-thread-support/
#               / mruby/mruby/ 32818bd2 :
#   Assertion failed: (((mrb)->is_generational_gc_mode) || mrb->gc_state != GC_STATE_NONE),
#       function mrb_write_barrier, file src/gc.c, line 1103.

  end

  def fls(pc2, *sym)
    return if 0 != @flg.size    # || 0 == pc2

    sym, r = @pl.rslts(pc2)

p "#{((pc2 >> 1) - 1).to_xeh} #{sym[0]} #{r[0].to_xeh}"
    case sym[0]
#    when :MOVE
    when 'MOVE'
#        @stack[@sp + getarg_a(cop)] = @stack[@sp + getarg_b(cop)]
      @stack[r[1]] = @stack[r[0]]
#    when :LOADL
    when 'LOADL'
#        @stack[@sp + getarg_a(cop)] = irep.pool[getarg_bx(cop)]
      @stack[r[1]] = irep.pool[r[0]]
#    when :LOADI
    when 'LOADI'
#        @stack[@sp + getarg_a(cop)] = getarg_sbx(cop)
      @stack[r[1]] = r[0]
#    when :LOADSYM
    when 'LOADSYM'
#        @stack[@sp + getarg_a(cop)] = irep.syms[getarg_bx(cop)]
      @stack[r[1]] = irep.syms[r[0]]
#    when :LOADSELF
    when 'LOADSELF'
#        @stack[@sp + getarg_a(cop)] = @stack[@sp]
      @stack[r[1]] = @stack[r[0]]
#    when :LOADT
    when 'LOADT'
#        @stack[@sp + getarg_a(cop)] = true
      @stack[r[1]] = r[0]
#    when :ADD
    when 'ADD'
#        @stack[@sp + getarg_a(cop)] += @stack[@sp + getarg_a(cop) + 1]
      @stack[r[1]] += @stack[r[0] + 1]
#    when :ADDI
    when 'ADDI'
#        @stack[@sp + getarg_a(cop)] += getarg_c(cop)
      @stack[r[1]] += r[0]
#    when :SUB
    when 'SUB'
#        @stack[@sp + getarg_a(cop)] -= @stack[@sp + getarg_a(cop) + 1]
      @stack[r[1]] -= @stack[r[0] + 1]
#    when :SUBI
    when 'SUBI'
#        @stack[@sp + getarg_a(cop)] -= getarg_c(cop)
      @stack[r[1]] -= r[0]
#    when :MUL
    when 'MUL'
#        @stack[@sp + getarg_a(cop)] *= @stack[@sp + getarg_a(cop) + 1]
      @stack[r[1]] *= @stack[r[0] + 1]
#    when :DIV
    when 'DIV'
#        @stack[@sp + getarg_a(cop)] /= @stack[@sp + getarg_a(cop) + 1]
      @stack[r[1]] /= @stack[r[0] + 1]
#    when :EQ
    when 'EQ'
#        val = (@stack[@sp + getarg_a(cop)] == @stack[@sp + getarg_a(cop) + 1])
#        @stack[@sp + getarg_a(cop)] = val
      val = @stack[r[1]] == @stack[r[0] + 1]
#      @stack[@sp + getarg_a(cop)] = val
      @stack[r[1]] = val
     end
  end

  def iset(sp , arg ,*sym)
    pl0 = @pl0
    pl1 = @pl1

#    i_th = pl0.index('th')
#    i_th = @pl.idx('th')
    i_th = @idx['th']
#    i_sym = pl0.index('sym')
#    i_sym = @pl.idx('sym')
    i_sym = @idx['sym']
#    i__sp = pl0.index('_sp')
#    i__sp = @pl.idx('_sp')
    i__sp = @idx['_sp']
#    i_ctr = pl0.index('ctr')
#    i_ctr = @pl.idx('ctr')
    i_ctr = @idx['ctr']
#    i_lf = @idx['lf']

    ab = 1 - sym.size
    pc2 = @pc << 1
    pc2ab = pc2 + ab

    fls(pc2, sym) if 0 == ab

    pl2 = @pl[pc2ab + 2]
    pl2[i__sp] = sp
    pl2[i_th] = arg
    pl2[i_sym] = sym[0]
    @pl[pc2ab + 2] = pl2

    pl1[i_ctr] += 1
#    pl1[i_lf] += 1
    @pl[1] = pl1
  end


  def eval(irep)
    plini
#    pc = @pc    ##
#    pl0 = @pl0
#    pl1 = @pl1
##    i__sp = pl0.index('_sp')
##    i__sp = @pl.idx('_sp')
#    i__sp = @idx['_sp']
#    pl1[i__sp] = @sp
#    @pl[1] = pl1

    @flg = [true]

    while true
      cop = irep.iseq[@pc]
      sp = @sp  ##

#     case Irep::OPTABLE_SYM[ get_opcode(cop)]
      sym = Irep::OPTABLE_SYM[ get_opcode(cop)]   ##
p "#{@pc.to_xeh} #{sym}"
       case sym  ##
      when :MOVE
#         @stack[@sp + getarg_a(cop)] = @stack[@sp + getarg_b(cop)]
        iset(sp, ['getarg_b', cop], sym)
        iset(sp, ['getarg_a', cop])

      when :LOADL
#        @stack[@sp + getarg_a(cop)] = irep.pool[getarg_bx(cop)]
        iset(0 , ['getarg_bx', cop], sym)
        iset(sp, ['getarg_a', cop])

      when :LOADI
#        @stack[@sp + getarg_a(cop)] = getarg_sbx(cop)  ##
        iset(0 , ['getarg_sbx', cop], sym)
        iset(sp, ['getarg_a', cop])

      when :LOADSYM
#        @stack[@sp + getarg_a(cop)] = irep.syms[getarg_bx(cop)]        ##
        iset(0 , ['getarg_bx', cop], sym)
        iset(sp, ['getarg_a', cop])

      when :LOADSELF
#        @stack[@sp + getarg_a(cop)] = @stack[@sp]      ##
        iset(sp , ['_im_', 0], sym)
        iset(sp, ['getarg_a', cop])

      when :LOADT
#        @stack[@sp + getarg_a(cop)] = true     ##
        iset(0 , ['_im_', true], sym)
        iset(sp, ['getarg_a', cop])

      when :ADD
#        @stack[@sp + getarg_a(cop)] += @stack[@sp + getarg_a(cop) + 1] ##
        iset(sp, ['getarg_a', cop], sym)
        iset(0, ['_sm_', 0])
#	iset(sp, ['getarg_a', cop])

      when :ADDI
#        @stack[@sp + getarg_a(cop)] += getarg_c(cop)   ##
        iset(0, ['getarg_c', cop], sym)
        iset(sp, ['getarg_a', cop])

      when :SUB
#        @stack[@sp + getarg_a(cop)] -= @stack[@sp + getarg_a(cop) + 1]
        iset(sp, ['getarg_a', cop], sym)
        iset(0, ['_sm_', 0])
#	iset(sp, ['getarg_a', cop])

      when :SUBI
#        @stack[@sp + getarg_a(cop)] -= getarg_c(cop)
        iset(0,  ['getarg_c', cop], sym)
        iset(sp, ['getarg_a', cop])

      when :MUL
#        @stack[@sp + getarg_a(cop)] *= @stack[@sp + getarg_a(cop) + 1]
        iset(sp, ['getarg_a', cop], sym)
        iset(0, ['_sm_', 0])
#	iset(sp, ['getarg_a', cop])

      when :DIV
#        @stack[@sp + getarg_a(cop)] /= @stack[@sp + getarg_a(cop) + 1]
        iset(sp, ['getarg_a', cop], sym)
        iset(0, ['_sm_', 0])
#	iset(sp, ['getarg_a', cop])

      when :EQ
#        val = (@stack[@sp + getarg_a(cop)] == @stack[@sp + getarg_a(cop) + 1])
#        @stack[@sp + getarg_a(cop)] = val
        iset(sp, ['getarg_a', cop], sym)
        iset(0, ['_sm_', 0])
#	iset(sp, ['getarg_a', cop])

      else
        iset(0 , ['~~', 0], sym)
        iset(0 , ['~~', 0])
#        pc2 = @pc << 1
#        fls(pc2, sym)

        plini
        @flg.pop
        @flg.push(true)
        @flg.push(true)


        case sym        ##
        when :NOP

        when :JMP
######        @pc = @pc + getarg_sbx(cop)
        @pc = @pc + getarg_sbx(cop) - 1
######        next

        when :JMPIF
#        if @stack[@sp + getarg_a(cop)] then
        if @stack[sp + getarg_a(cop)] then
######          @pc = @pc + getarg_sbx(cop)
          @pc = @pc + getarg_sbx(cop) - 1
######          next
         end

        when :JMPNOT
#        if !@stack[@sp + getarg_a(cop)] then
          if !@stack[sp + getarg_a(cop)] then
######          @pc = @pc + getarg_sbx(cop)
          @pc = @pc + getarg_sbx(cop) - 1
######          next
         end

        when :ENTER

        when :SEND
#        a = getarg_a(cop)
         a = getarg_a(cop)
#        mid = irep.syms[getarg_b(cop)]
        mid = irep.syms[getarg_b(cop)]
#        n = getarg_c(cop)      ##
        n = getarg_c(cop)
#        newirep = Irep::get_irep(@stack[@sp + a], mid)
        newirep = Irep::get_irep(@stack[sp + a], mid)
        if newirep then
#          @callinfo[@cp] = @sp
          @callinfo[@cp] = sp
          @cp += 1
          @callinfo[@cp] = @pc
          @cp += 1
          @callinfo[@cp] = irep
          @cp += 1
#          @sp += a
          sp += a
######          @pc = 0
          @pc = -1
          irep = newirep

######          next
        else
          args = []
          n.times do |i|
#            args.push @stack[@sp + a + i + 1]
            args.push @stack[sp + a + i + 1]
          end

#          @stack[@sp + a] = @stack[@sp + a].send(mid, *args)
          @stack[sp + a] = @stack[sp + a].send(mid, *args)
        end

        when :RETURN
         if @cp == 0 then
#          return @stack[@sp + getarg_a(cop)]
          return @stack[sp + getarg_a(cop)]
         else
#          @stack[@sp] = @stack[@sp + getarg_a(cop)]
          @stack[sp] = @stack[sp + getarg_a(cop)]
          @cp -= 1
          irep = @callinfo[@cp]
          @cp -= 1
          @pc = @callinfo[@cp]
          @cp -= 1
#          @sp = @callinfo[@cp]
          sp = @callinfo[@cp]
         end
        else
         printf("Unkown code %s \n", Irep::OPTABLE_SYM[get_opcode(cop)])
        end
      end

##      iset(sym, ary) if [] != ary

      @flg.pop
      @pc = @pc + 1
      @sp = sp  ##
    end

    @rmt.join

  end
end

class Irep
  OPTABLE_SYM = []
  OPTABLE_CODE = {}
  OPTABLE.each do |ent|
    OPTABLE_SYM.push ent.to_sym
  end
  op = 0
  OPTABLE_SYM.each do |sym|
    OPTABLE_CODE[sym] = op
    op = op + 1
  end
end
