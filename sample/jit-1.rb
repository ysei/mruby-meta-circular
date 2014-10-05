# -*- coding: iso-2022-jp -*-

module M__Object
  def mapr(&block)
#    return a.map { |v|
#      knid(v, 'Array') ? v = mapr(v, &block) : yield(v)
#    }
#   knid(self, 'Array') ? self.map { |v| v.__send__(&block)} : yield(self)
    knid(self, 'Array') ? self.map { |v| v.mapr(&block)} : yield(self)
  end

  def to_i_from(k, i = 0)
#   self.is_a?(k) ? i + self.to_i : self	# unwork ? ( thread ? ) # mrblib/
    knid(k, self) ? i + self.to_i : self	# unwork ? ( thread ? ) # mrblib/
  end

# def kind_of?(k)
##  self.class == k.class
#   self.kind_of?(k)	# unwork ? ( thread ? )
# end

  def knid(v, k)
    tp = [['Array',  Class::Array ], ['Numeric', Class::Numeric],
	  ['Fixnum', Class::Fixnum], ['Float',   Class::Float  ],
	  ['String', Class::String]]
    return v.kind_of?(tp.assoc(k)[1]) if 0.kind_of?(Numeric)	# super

#   k = tp.assoc(k)[1]	# unwork ? ( thread ? )
    if v == vs = v.to_s
#     String == k
      'String' == k
    else
      sn = ['Numeric', 'Float'].include?(k) ? (k = 'Fixnum'; '.') : ''

      case k
      when 'Array'
#     when Array
	'[]' == vs[0] + vs[-1]
      when 'Fixnum'
#     when Fixnum
	sn += (0 .. 9).to_a.join + '-'	# * ''
	vs.each_byte { |c| break if ! sn.include?(c)}
      else
	false
      end
    end
  end
end

class Object
  include M__Object
end

module M__Numeric
  def to_xeh	# unwork mruby 60410200 # mrblib/
    self.to_i.to_s(0x10).reverse
  end

# def pid_g
#   $$ || self
# end
end

class Numeric
  include M__Numeric
end

class Array
# def width	# unwork ( thread ? ) # mrblib/
#   self.size - 1
# end
end

module M__Imem
  include RiteOpcodeUtil

  def initialize
  end

# def kndof(v, k)	# unwork ( thread ? )
#   v.is_a?(k)
# end

  def mcall(*op)
    knid(op[0], 'Numeric') ? op.inject(:+) : self.send(*op)
  end
end

class Imem
  include M__Imem
end

module M__ENVary
  @@slp = 0.0001
# @imem = Imem.new	# higokan mruby 80410200
  @@imem = Imem.new

  @@fl = '~~ritepl'
  @@idb = @@fl
  @@fl += '.loc'
# @@idb = 0.pid_g.to_xeh + @@idb	# +
#   (rand 0xff).to_xeh +
#   (Time.now.to_f - 0x3fffffff.to_f << 0x10).to_s.split('.')[0][-8..-1].to_xeh
# @@dlm = '\n'
# @@dlm = '__--__'
# @@idx = Hash.new


  def initialize(*a)
#   @m = Mutex.new
#   @@idx = []
#   @imem = Imem.new	# higokan mruby 80410200

    n = a.shift
#   @sz = a.size
    if 1 > n
#     @n = -n
#     return self[@n]
      return
    end
#   @ary = Array.new(n)
    (0..n).each{ |i|
#     @ary = a
      self[i] = *a
    }
  end


# @@ploc = Fiber.new { |a|
# @@ploc = Proc.new { |*a|
  def ploc(*a)
#   @m.lock
    begin
      f = File.open(@@fl, 'w')
      f.flock(File::LOCK_EX)
    rescue
      self.slp
      retry
    end
    r = true
    a[0] = a[0].to_xeh
    r = yield a
    f.close
#   @m.unlock
    r
#   a = yield(r)
  end
# }


  def []=(n, v)
#   ENV[@@idb + n.to_s] = v.to_msgpack
#   ENV[@@idb + n.to_s] = MsgPack.dump(v)
##  ENV[@@idb + n.to_s] = JSON::generate(v)
    ploc(n, v) { |a| ENV[@@idb + a[0]] = JSON::generate(a[1])}
#   @@ploc.call(n, v)
#   $ploc.resume([n, v])
#   super
  end
  def [](n)
#   MessagePack.unpack(ENV[@@idb + n.to_s])
#   MsgPack.load(ENV[@@idb + n.to_s])
##  JSON::parse(ENV[@@idb + n.to_s])
    ploc(n) { |a| JSON::parse(ENV[@@idb + a[0]])}
#   @@ploc.call(n)
#   $ploc.resume([n])
#   super
  end
##def [](n = true)
#   MessagePack.unpack(ENV[@@idb + n.to_s])
#   if n
#     ary = []
#     (0 .. @sz).each { |i|
#       ary[i] = JSON::parse(ENV[@@idb] + n)
#     }
#     ary
#   else
#     JSON::parse(ENV[@@idb + n])
#     @@ploc.call(n)
##    self.ploc(n)
#   end
##end

  def affil(k = '')	# higokan mruby 10410200 ( irep.rb )
#    self[0].index(k)
    self[0][0].index(k)
#    @@idx[k]
  end

#  def idx_s
#    pl = self[0]
#    idx = Hash.new
#    for n in (0 ... pl.size)
#      key = pl[n]
#      idx[key] = n
#    end
#    @@idx = idx
#  end

  def idx0(n = 0, t = 1)
    t > n ? n + 1 : n
  end

  def pl_g(n = 0)
#   sleep 0; GC.start; sleep 0
#   self[n < 0 ? n + 1 : n][self.idx0(n)]
    pl = self[self.idx0(n, 0)]
#   1 > n ? pl[self.idx0(n)] : pl
    if 1 > n then pl = pl[self.idx0(n)] end
    pl = mapr(pl) { |v|
      v.to_i_from(Numeric)
    } if Float == self[self.affil('ctr')].class
    pl
  end

  def pl_s(n = 0, pl)
    self[n] = 0 == n ? [pl_g(-1), pl] : pl
  end

  def pl_eg(n = 0, k)
    pl_g(n)[self.affil(k)]
  end

# def pl_es(n = 0, *ary)
  def pl_es(n = 0, ary)
#   pl[0 == n ? 1 : nil][self.idx(k)] = v
#   n = arg.shift if arg.first.is_a?(Numeric)	# unwork ( thread ? )
#   arg[0].is_a?(Numeric) ? n = arg.shift : n = 0	# unwork ( thread ? )

    pl = pl_g(n)
    ary.each_slice(2) { |k, v|
      pl[self.affil(k)] = v
    }
    pl_s(n, pl)
  end

  def ctr_g
#    [pl_eg('ctr').to_i, pl_eg('cto').to_i]
    [pl_eg('ctr'), pl_eg('cto')]
  end

  def ctr_s(cto)
#   pl_es('cto', cto)
    pl_es(0, ['cto', cto])
  end

# def lf_i
#   self[1][self.idx('lf')] += 1
#   self[1][@@idx['lf']] += 1
# def lf_d

  def slp(t = @@slp)
    sleep t
#   (0 .. self.size << 4).each {
#     (true == true).is_a?(Object)
#   }
  end

  def ckth(th, tp)
#   self[pc][idx('th')].is_a?(Array)	# higokan mruby 10410200 ( irep.rb )
#   ! th.is_a?(Array)
    if 'ar' == tp
      ! th.is_a?(Array)
#   elsif tp.is_a?(Numeric)
    else
#     re = th[0][tp]
      false != th[tp]	# nil : true
    end
  end

# @@st_id = Proc.new { |a|
  def st_id(a, pc)
#   return a if [] == a or ! knid(a, 'Array')
    a = a.map { |v|
#     v.kind_of?(Array) ? __send__(v, pc) : v	# unwork ( thread ? )
#     @@imem.kndof(v, Array) ? __send__(v, pc) : v	# unwork ( thread ? )
#     knid(v, 'Array') ? __send__(v, pc) : v
      knid(v, 'Array') ? st_id(v, pc) : v
  }
#    return a[0].to_i_from(Numeric) if 2 > a.size
    return a[0] if 2 > a.size

##   opc = a.first
#    opc = a.first.to_i_from(Numeric)
#    op = a.last.to_i_from(Numeric)
#   GC.start
    a.inject { |opc, op|
#p "#{pc.to_xeh} #{opc} #{op.to_xeh}"
p "#{pc.to_xeh} #{opc} #{op.to_xeh}" if ! knid(opc, 'Numeric')
#    @@imem.mcall(opc.to_sym, op).to_i_from(Numeric) || op
      @@imem.mcall(opc, op) || op
    }
  end

  def pl(pc = 1)
    i_th = self.affil('th')	# higokan mruby 10410200 ( irep.rb )
#   i_th = @@idx['th']
#   i_lf = self[0].index('lf')

    pl = plg(pc, 0)

    for idx in (0 ... pl[i_th].size)
#p    "#{pc.to_xeh} #{pl2[0][0]} #{pl2[0][1].to_xeh}"

#     a = @@st_id.call(a)
#     a = st_id(a)
      pl[i_th][idx] = st_id(pl[i_th][idx], pc - 1)

    end
    pl_s(pc, pl)
##  self.lf_d
#   GC.start
  end

  def plw(pc = 1)
#   cto = 0
    loop do
#     pc = self.ctr_g
      pc, cto = self.ctr_g
      if pc != cto
#	cto += 1
#	an[cto] = Thread.new(envid) { |envid|

#	self.pl(cto)
#	self.pl(pc - 1)
	self.pl(pc)
	self.ctr_s(cto = pc)
      end
      self.slp
#     sleep 0.002
#     sleep 0.00001
####  GC.start
    end
  end

#  private

  def plg(pc, md = 1)
    i_th = self.affil('th')
    tp = [md, 'ar'][md]
    while pl = pl_g(pc)		# and 0 != pc do
      th = pl[i_th]
#      max ||= md & (th.size - 1)
      max ||= md & th.width
#     max.step(0, -1) { |idx|	# higokan ? mruby 70410200
      (0 .. max).reverse_each { |idx|
	break if ! ckth(th[idx], tp)
	return(pl) if 0 == idx
      }
      self.slp
#     sleep 0.00001
    end
#   self[pc] = pl
  end

  def rslt(pc)
    i_th = self.affil('th')
#   i_th = @@idx['th']
#    i__sp = self.affil('_sp')
    i_sym = self.affil('sym')

    pl = plg(pc)

    r = pl[i_th]
#    for idx in (0 ... pl[i_th].size)
#      r[idx] = r[idx].to_i_from(Numeric, pl[i__sp][idx])
#      r[idx] = r[idx].to_i_from(Numeric)
#      r[idx] = r[idx]
#    end
    r[1] = r[-1]
    [pl[i_sym], r]
  end
end

class ENVary
# include RiteOpcodeUtil
  include M__ENVary
end

class Stack < Array
  def initialize(sp = 0)
    @sp = [sp, sp]
    @ofs = [0, 0]
  end
  def []=(*a)
    a = a.each { |v|}
#      case v.is_a?(String)
#    when true
    sd = b.shift
    @ofs[['S', 'D'].index(sd)] = b.first
#      case b.shift
#      when 'S'
#	@sp[0] = b.first
#      when 'D'
#	@sp[1] = b.first
#      end
#    else
      super
#    end
  end

  def ofs(*a)
    sd = a.shift
    @ofs[['S', 'D'].index(sd)] = a.first
  end

  def sp_g(sp = 0)
    @sp
  end
end

class FibVM
# include RiteOpcodeUtil
  OPTABLE_CODE = Irep::OPTABLE_CODE
  OPTABLE_SYM = Irep::OPTABLE_SYM

  def initialize
    @flg = []
    @imem = Imem.new

    # For Interpriter
    @stack = []			# スタック(@spより上位をレジスタとして扱う)
    @callinfo = []		# メソッド呼び出しで呼び出し元の情報を格納
    @pc = 0			# 実行する命令の位置
    @sp = 0			# スタックポインタ
    @cp = 0			# callinfoのポインタ
    @irep = [nil]		# 現在実行中の命令列オブジェクト
    @irepid =nil		# 命令列オブジェクトのid(JIT用)


#   rmth = 63
#   rmth = 47
    rmth = 39
#   @pla = Array.new($pcmax)
#   $pltini.call()
    thini = [false, 0]
    @pl = ENVary.new(rmth + 1, [thini], [], [])

    plini
#   @pl.idx_s

#   @idx = Hash.new
#   pl0 = @pl0
#   for n in (0 ... pl0.size)
#     k = pl0[n]
#     @idx[k] = n
#   end

    @rmt = wkth
    GC.disable	# gene gc on : mruby 6170410200 d17506c1

#   5ff9c1d2 : ( irep.rb ) 
#   Assertion failed: ((obj)->tt != MRB_TT_FREE), function mrb_gc_mark, file src/gc.c, line 577.

#   ysei/mruby-thread/tree/normal/ 4c02f126
#       / mruby-thread/crimsonwoods/tree/experimental-thread-support/
#               / mruby/mruby/ 32818bd2 : ( irep.rb ) 
#   Assertion failed: (((mrb)->is_generational_gc_mode) || mrb->gc_state != GC_STATE_NONE),
#       function mrb_write_barrier, file src/gc.c, line 1103.

  end

  def plini
    thini = false

    # 3080410200 : gene gc off : mruby 6170410200 d17506c1
    # 3080410200 : 5x2 ng ( segmentation fault ) : mruby 3080410200 0878900f
    # 3080410200 : 5x2 ok ( gc ) : monami-ya.mrb 8270410200 813e2af8
#    @pl[0] = [['th',  'sym', '_sp', 'ctr', 'cto'],	# mruby 20410200 : higokan ? : ary_many
#	      [[thini],  0,    [0],    0,     0]]	# mruby 70410200 : 4x2 ok , 5x2 ng
    @pl[0] = [['th',  'sym', 'ctr', 'cto'],	# mruby 20410200 : higokan ? : ary_many
	      [[thini],  0,     0,     0]]	# mruby 70410200 : 4x2 ok , 5x2 ng

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
#   Thread.new($pcmax) { |pcmax|
    Thread.new(pc) { |pc|
      ENVary.new(0).plw(pc)
    }
  end

# def stack_g(sp = @sp)
#   @stack[sp]
# end

# def stack_s(v, sp = @sp, sym = nil)
#   @stack[sp] = nil == sym ? v :
#     [v].inject(stack_g(sp), sym)
# end

  def fls(pc)
    return if 0 != @flg[0]

#   syms = [['ADD', :+], ['SUB', :-], ['MUL', :*], ['DIV', :/]]	# :=

    sym, r = @pl.rslt(pc)
    r0, r1 = r

p "#{(pc - 1).to_xeh} #{sym} #{r1.to_xeh} #{r0.to_xeh}"

    case sym.to_sym
    when :MOVE
#     @stack[@sp + getarg_a(cop)] = @stack[@sp + getarg_b(cop)]
#     stack_s(stack_g(r0), r1)
      @stack[r1] = @stack[r0]
    when :LOADL
#     @stack[@sp + getarg_a(cop)] = @irep.pool[getarg_bx(cop)]
#     stack_s(@irep[0].pool[r0], r1)
      @stack[r1] = @irep[0].pool[r0]
    when :LOADI
#     @stack[@sp + getarg_a(cop)] = getarg_sbx(cop)
#     stack_s(r0, r1)
      @stack[r1] = r0
    when :LOADSYM
#     @stack[@sp + getarg_a(cop)] = @irep.syms[getarg_bx(cop)]
#     stack_s(@irep[0].syms[r0], r1)
      @stack[r1] = @irep[0].syms[r0]
    when :LOADSELF
#     @stack[@sp + getarg_a(cop)] = @stack[@sp]
#     stack_s(stack_g(r0), r1)
      @stack[r1] = @stack[r0]
    when :LOADT
#     @stack[@sp + getarg_a(cop)] = true
#     stack_s(r0, r1)
      @stack[r1] = r0
    when :ADD
#     @stack[@sp + getarg_a(cop)] += @stack[@sp + getarg_a(cop) + 1]
#     stack_s(stack_g(r0 + 1), r1, :+)
      @stack[r1] += @stack[r0 + 1]
    when :ADDI
#     @stack[@sp + getarg_a(cop)] += getarg_c(cop)
#     stack_s(r0, r1, :+)
      @stack[r1] += r0
    when :SUB
#     @stack[@sp + getarg_a(cop)] -= @stack[@sp + getarg_a(cop) + 1]
#     stack_s(stack_g(r0 + 1), r1, :-)
      @stack[r1] -= @stack[r0 + 1]
    when :SUBI
#     @stack[@sp + getarg_a(cop)] -= getarg_c(cop)
#     stack_s(r0, r1, :-)
      @stack[r1] -= r0
    when :MUL
#     @stack[@sp + getarg_a(cop)] *= @stack[@sp + getarg_a(cop) + 1]
#     stack_s(stack_g(r0 + 1), r1, :*)
      @stack[r1] *= @stack[r0 + 1]
    when :DIV
#     @stack[@sp + getarg_a(cop)] /= @stack[@sp + getarg_a(cop) + 1]
#     stack_s(stack_g(r0 + 1), r1, :/)
      @stack[r1] /= @stack[r0 + 1]
    when :EQ
#     val = (@stack[@sp + getarg_a(cop)] == @stack[@sp + getarg_a(cop) + 1])
#     @stack[@sp + getarg_a(cop)] = val
#     val = stack_g(r1) == stack_g(r0 + 1)
      val = @stack[r1] == @stack[r0 + 1]
#     @stack[@sp + getarg_a(cop)] = val
#     stack_s(val, r1)
      @stack[r1] = val
    end
  end

  def iset(pc, ops)
    pc1 = pc + 1
    pl = @pl
#   i_lf = @idx['lf']

#    pl.pl_es(pc1, ['sym', '_sp', 'th'].flat_map { |o| [o].push(ops.shift)})
    pl.pl_es(pc1, ['sym', 'th'].flat_map { |o| [o].push(ops.shift)})
    pl.pl_es(0,   ['ctr', pc1])

#   pl1[i_ctr] += 1
#   pl1[i_lf] += 1
  end

  def eval(irep)
    ppll = @pl
    imem = @imem

    @irep[0] = irep
#   @irepid = @irep.id
    @irepid = irep.id

    @flg[0] = 1

    while true
      pc = @pc

      #　命令コードの取り出し
#     cop = @irep.iseq[@pc]
      cop = irep.iseq[pc]
      sp = @sp ##
      ops = []

#     case OPTABLE_SYM[get_opcode(cop)]
#     sym = OPTABLE_SYM[get_opcode(cop)]
#      sym = OPTABLE_SYM[ppll.get_opcode(cop)]
      sym = OPTABLE_SYM[imem.get_opcode(cop)]
p "#{pc.to_xeh} #{sym} #{cop}"

      case sym
	# 何もしない
      when :NOP

	# MOVE Ra, RbでレジスタRaにレジスタRbの内容をセットする
      when :MOVE
#       @stack[@sp + getarg_a(cop)] = @stack[@sp + getarg_b(cop)]
#	ops = [[sp, ['getarg_b', cop]], [sp, ['getarg_a', cop]]]
#	ops = [[sp, sp], [['getarg_b', cop], ['getarg_a', cop]]]
	ops = [[[sp, ['getarg_b', cop]], [sp, ['getarg_a', cop]]]]

	# LOADL Ra, pb でレジスタRaに定数テーブル(pool)のpb番目の値をセットする
      when :LOADL
#	@stack[@sp + getarg_a(cop)] = @irep.pool[getarg_bx(cop)]
#	ops = [[0, ['getarg_bx', cop]], [sp, ['getarg_a', cop]]]
#	ops = [[0, sp], [['getarg_bx', cop], ['getarg_a', cop]]]
	ops = [[['getarg_bx', cop], [sp, ['getarg_a', cop]]]]

	# LOADI Ra, n でレジスタRaにFixnumの値 nをセットする
      when :LOADI
#       @stack[@sp + getarg_a(cop)] = getarg_sbx(cop)
#	ops = [[0, sp], [['getarg_sbx', cop], ['getarg_a', cop]]]
	ops = [[['getarg_sbx', cop], [sp, ['getarg_a', cop]]]]

#     when :LOADSYM
#	@stack[@sp + getarg_a(cop)] = irep.syms[getarg_bx(cop)]

	# LOADSELF Ra でレジスタRaに現在のselfをセットする
      when :LOADSELF
#	@stack[@sp + getarg_a(cop)] = @stack[@sp]
#	ops = [[sp, sp], [['mk_opcode', 0], ['getarg_a', cop]]]	# mk_opcode 0
	ops = [[[sp], [sp, ['getarg_a', cop]]]]	# [sp]

#     when :LOADT
#	@stack[@sp + getarg_a(cop)] = true

	# ADD Ra, Rb でレジスタRaにRa+Rbをセットする
      when :ADD
#	@stack[@sp + getarg_a(cop)] += @stack[@sp + getarg_a(cop) + 1]
#	ops = [[sp], [['getarg_a', cop]]]
	ops = [[[sp, ['getarg_a', cop]]]]

#     when :ADDI
#	@stack[@sp + getarg_a(cop)] += getarg_c(cop)

#     when :SUB
#	@stack[@sp + getarg_a(cop)] -= @stack[@sp + getarg_a(cop) + 1]

	# SUB Ra, n でレジスタRaにRa-nをセットする
      when :SUBI
#	@stack[@sp + getarg_a(cop)] -= getarg_c(cop)
#	ops = [[['getarg_c', cop], ['getarg_a', cop]]]
	ops = [[['getarg_c', cop], [sp, ['getarg_a', cop]]]]

#     when :MUL
#	@stack[@sp + getarg_a(cop)] *= @stack[@sp + getarg_a(cop) + 1]

#     when :DIV
#	@stack[@sp + getarg_a(cop)] /= @stack[@sp + getarg_a(cop) + 1]

	# EQ Ra でRaとR(a+1)を比べて同じならtrue, 違うならfalseをRaにセットする
      when :EQ
#	val = (@stack[@sp + getarg_a(cop)] == @stack[@sp + getarg_a(cop) + 1])
#	@stack[@sp + getarg_a(cop)] = val
#	ops = [[sp], [['getarg_a', cop]]]
	ops = [[[sp, ['getarg_a', cop]]]]
      end

      fls(pc)

      if 0 != ops.size
	iset(pc, [sym] + ops)
      else

#	while (ctr, cto = ppll.ctr_g) and ctr != cto # pc != cto
#	  ppll.slp
#	end

	plini
	@flg[0] = 2

	case sym

	  # JMP nでpcをnだけ増やす。ただし、nは符号付き
	when :JMP
##	  @pc = @pc + getarg_sbx(cop)
#	  pc = pc + ppll.getarg_sbx(cop) - 1
	  pc = pc + imem.getarg_sbx(cop) - 1
##	  next

	when :JMPIF
#	  if @stack[@sp + getarg_a(cop)] then
#	  if @stack[sp + ppll.getarg_a(cop)] then
	  if @stack[sp + imem.getarg_a(cop)] then
#	    @pc = @pc + getarg_sbx(cop)
#	    pc = pc + ppll.getarg_sbx(cop) - 1
	    pc = pc + imem.getarg_sbx(cop) - 1
#	    next
	  end

	  # JMPNOT Ra, nでもしRaがnilかfalseならpcをnだけ増やす。ただし、nは符号付き
	when :JMPNOT
###	  if !@stack[@sp + getarg_a(cop)] then
#	  if !@stack[sp + ppll.getarg_a(cop)] then
	  if !@stack[sp + imem.getarg_a(cop)] then
##	    @pc = @pc + getarg_sbx(cop)
#	    pc = pc + ppll.getarg_sbx(cop) - 1
	    pc = pc + imem.getarg_sbx(cop) - 1
##	    next
	  end

	  # メソッドの先頭で引数のセットアップする命令。面倒なので詳細は省略
	when :ENTER

	  # SEND Ra, mid, anumでRaをレシーバにしてシンボルmidの名前のメソッドを
	  # 呼び出す。ただし、引数はanum個あり、R(a+1), R(a+2)... R(a+anum)が引数
	when :SEND
#	  a = getarg_a(cop)
#	  a = ppll.getarg_a(cop)
	  a = imem.getarg_a(cop)
#	  mid = @irep.syms[getarg_b(cop)]
#	  mid = irep.syms[ppll.getarg_b(cop)]
	  mid = irep.syms[imem.getarg_b(cop)]
#	  n = getarg_c(cop)
#	  n = ppll.getarg_c(cop)
	  n = imem.getarg_c(cop)
###	  newirep = Irep::get_irep(@stack[@sp + a], mid)
	  newirep = Irep::get_irep(@stack[sp + a], mid)
	  if newirep then
###	    @callinfo[@cp] = @sp
	    @callinfo[@cp] = sp
	    @cp += 1
#	    @callinfo[@cp] = @pc
	    @callinfo[@cp] = pc
	    @cp += 1
#	    @callinfo[@cp] = @irep
	    @callinfo[@cp] = irep
	    @cp += 1
###	    @sp += a
	    sp += a
##	    @pc = 0
	    pc = -1
#	    @irep = newirep
	    irep = newirep
#	    @irepid = @irep.id
	    @irepid = irep.id

##	    next
	  else
	    args = []
	    n.times do |i|
###	      args.push @stack[@sp + a + i + 1]
	      args.push @stack[sp + a + i + 1]
	    end

###	    @stack[@sp + a] = @stack[@sp + a].send(mid, *args)
	    @stack[sp + a] = @stack[sp + a].send(mid, *args)
	  end

	  # RETURN Raで呼び出し元のメソッドに戻る。Raが戻り値になる
	when :RETURN
	  if @cp == 0 then
###	    return @stack[@sp + getarg_a(cop)]
#	    return @stack[sp + ppll.getarg_a(cop)]
	    return @stack[sp + imem.getarg_a(cop)]
	  else
###	    @stack[@sp] = @stack[@sp + getarg_a(cop)]
#	    @stack[sp] = @stack[sp + ppll.getarg_a(cop)]
	    @stack[sp] = @stack[sp + imem.getarg_a(cop)]
	    @cp -= 1
#	    @irep = @callinfo[@cp]
	    irep = @callinfo[@cp]
#	    @irepid = @irep.id
	    @irepid = irep.id
	    @cp -= 1
###	    @pc = @callinfo[@cp]
	    pc = @callinfo[@cp] - 1
	    @cp -= 1
###	    @sp = @callinfo[@cp]
	    sp = @callinfo[@cp]
	  end
	else
	  printf("Unkown code %s \n", OPTABLE_SYM[get_opcode(cop)])
	end
      end

      @flg[0] >>= 1
      @pc = pc + 1
      @sp = sp ##
      @irep[0] = irep
    end

    @rmt.join

  end
end

def fib(n)
  if n == 1 then
    1
  elsif n == 0 then
    1
  else
    fib(n - 1) + fib(n - 2)
  end
end

def fibt
  fib(20)
end

a = Irep::get_irep(self, :fibt)
vm = FibVM.new
p vm.eval(a)
p fibt
