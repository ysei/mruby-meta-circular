module RiteOpcodeUtil
  def get_opcode(op)
    op & 0x7f
  end

  def getarg_a(op)
    (op >> 23) & 0x1ff
  end

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
  end

  def eval(irep)
    while true
      cop = irep.iseq[@pc]
      case Irep::OPTABLE_SYM[get_opcode(cop)]
      when :NOP

      when :MOVE
        @stack[@sp + getarg_a(cop)] = @stack[@sp + getarg_b(cop)]

      when :LOADL
        @stack[@sp + getarg_a(cop)] = irep.pool[getarg_bx(cop)]

      when :LOADI
        @stack[@sp + getarg_a(cop)] = getarg_sbx(cop)

      when :LOADSYM
        @stack[@sp + getarg_a(cop)] = irep.syms[getarg_bx(cop)]

      when :LOADSELF
        @stack[@sp + getarg_a(cop)] = @stack[@sp]

      when :LOADT
        @stack[@sp + getarg_a(cop)] = true

      when :ADD
        @stack[@sp + getarg_a(cop)] += @stack[@sp + getarg_a(cop) + 1]

      when :ADDI
        @stack[@sp + getarg_a(cop)] += getarg_c(cop)

      when :SUB
        @stack[@sp + getarg_a(cop)] -= @stack[@sp + getarg_a(cop) + 1]

      when :SUBI
        @stack[@sp + getarg_a(cop)] -= getarg_c(cop)

      when :MUL
        @stack[@sp + getarg_a(cop)] *= @stack[@sp + getarg_a(cop) + 1]

      when :DIV
        @stack[@sp + getarg_a(cop)] /= @stack[@sp + getarg_a(cop) + 1]

      when :EQ
        val = (@stack[@sp + getarg_a(cop)] == @stack[@sp + getarg_a(cop) + 1])
        @stack[@sp + getarg_a(cop)] = val

      when :JMP
        @pc = @pc + getarg_sbx(cop)
        next

      when :JMPIF
        if @stack[@sp + getarg_a(cop)] then
          @pc = @pc + getarg_sbx(cop)
          next
        end

      when :JMPNOT
        if !@stack[@sp + getarg_a(cop)] then
          @pc = @pc + getarg_sbx(cop)
          next
        end

      when :ENTER

      when :SEND
        a = getarg_a(cop)
        mid = irep.syms[getarg_b(cop)]
        n = getarg_c(cop)
        newirep = Irep::get_irep(@stack[@sp + a], mid)
        if newirep then
          @callinfo[@cp] = @sp
          @cp += 1
          @callinfo[@cp] = @pc
          @cp += 1
          @callinfo[@cp] = irep
          @cp += 1
          @sp += a
          @pc = 0
          irep = newirep

          next
        else
          args = []
          n.times do |i|
            args.push @stack[@sp + a + i + 1]
          end

          @stack[@sp + a] = @stack[@sp + a].send(mid, *args)
        end

      when :RETURN
        if @cp == 0 then
          return @stack[@sp + getarg_a(cop)]
        else
          @stack[@sp] = @stack[@sp + getarg_a(cop)]
          @cp -= 1
          irep = @callinfo[@cp]
          @cp -= 1
          @pc = @callinfo[@cp]
          @cp -= 1
          @sp = @callinfo[@cp]
        end
      else
        printf("Unkown code %s \n", Irep::OPTABLE_SYM[get_opcode(cop)])
      end

      @pc = @pc + 1
    end
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
