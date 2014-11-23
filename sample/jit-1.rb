# -*- coding: iso-2022-jp -*-

module M__Object
  def mapr(&block)
#   knid(self, 'Array') ? self.map { |v| v.__send__(&block)} : yield(self)
    knid(self, 'Array') ? self.map { |v| v.mapr(&block)} : yield(self)
  end

  def to_i_from(k, i = 0)
#   self.is_a?(k) ? i + self.to_i : self	# unwork ? ( thread ? ) # mrblib/
#   knid(k, self) ? i + self.to_i : self	# unwork ? ( thread ? ) # mrblib/
    self.class.to_s == k.to_s ? i + self.to_i : self	# unwork ? ( thread ? ) # mrblib/
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

module M__Array
  def affil(k, m = self)	# unwork ( thread ? ) # mrblib/
#   self[0].index(k)	# higokan mruby 10410200 ( irep.rb )
    'i' == m ? self[0][0].index(k) : self[m.affil(k, 'i')]	# self.index(idx)
  end

# def width	# unwork ( thread ? ) # mrblib/
#   self.size - 1
# end
end

class Array
  include M__Array
end

module M__Imem
  include RiteOpcodeUtil

  def initialize
    @cop = 0
  end

  def mcall(*op)
    knid(op[0], 'Fixnum') ? op.inject(:+) : self.send(*op)
  end
end

class Imem
  include M__Imem
end

module M__Slp
  @@slp = 0.00001
  def slp(t = @@slp, r = 1)
    (r - 1).times {sleep 0}; GC.start; r.times {sleep t}
#   (0 .. self.size << 4).each {
#     sleep 0; (true == true).is_a?(Object); sleep 0
#   }
  end
end

class Slp
  include M__Slp
end

#module M__ENVary	# higokan ? mruby 70410200
class ENVary < Array
# include RiteOpcodeUtil

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
    } if Float == self.affil('ctr')[0].class
    pl
  end

  def pl_s(n = 0, pl)
    self[n] = 0 == n ? [pl_g(-1), pl] : pl
  end

  def pl_eg(n = 0, k)
    pl_g(n).affil(k, self)
  end

  def pl_es(n = 0, ary)
#   pl[0 == n ? 1 : nil][self.idx(k)] = v
#   n = arg.shift if arg.first.is_a?(Numeric)	# unwork ( thread ? )
#   arg[0].is_a?(Numeric) ? n = arg.shift : n = 0	# unwork ( thread ? )

    pl = pl_g(n)
    ary.each_slice(2) { |k, v|
      pl[self.affil(k, 'i')] = v
    }
    pl_s(n, pl)
  end

  def ctr_g
    ctr, cto = [pl_eg('ctr')[0], pl_eg('cto')[0]]
    cto_s(ctr) if ctr != cto
    [ctr, cto]
  end

  def ctr_s(ctr)
    pl_es(0, ['ctr', [ctr]])
  end

  def cto_s(cto)
#   pl_es('cto', cto)
    pl_es(0, ['cto', [cto]])
  end

  def ctr_c(cto)
    pl_eg('ctr')[0] == pl_eg('cto')[0]
  end

# def lf_i
#   self[1][self.idx('lf')] += 1
#   self[1][@@idx['lf']] += 1
# def lf_d

  def ckth(th, md)
#   self[pc][idx('th')].is_a?(Array)	# higokan mruby 10410200 ( irep.rb )
    [true, false].index(knid(th, 'Array')) == md
  end

  def st_id(a, pc)
#   return a if [] == a or ! knid(a, 'Array')
    a = a.map { |v|
#     v.kind_of?(Array) ? __send__(v, pc) : v	# unwork ( thread ? )
#     @@imem.kndof(v, Array) ? __send__(v, pc) : v	# unwork ( thread ? )
#     knid(v, 'Array') ? __send__(v, pc) : v
      knid(v, 'Array') ? st_id(v, pc) : v
    }
    return a[0] if 2 > a.size

#   GC.start
    a.inject { |opc, op|
print "#{pc.to_xeh}		#{opc}	#{op.to_xeh}\n" if ! knid(opc, 'Numeric')
      @@imem.mcall(opc, op) || op
    }
  end

# def pl(pc, idx, th)
  def pl(pc)
#   i_th = self.affil('th', 'i')	# higokan mruby 10410200 ( irep.rb )
#   i_lf = self[0].index('lf')
    th = []	##
    idx = 0	##
    Fiber.new {	##
#   for idx in (ith .. (mx = th.width))
#   for idx in (ith .. mx = (th = pl_eg(pc, 'th')).width)
#   th[idx .. -1] = (thn = pl_eg(pc, 'th'))[idx .. -1]	###
      while (th[idx .. -1] = (thn = pl_eg(pc, 'th'))[idx .. -1])	##
	th = th[0 .. (mx = thn.width)]
	flg = false	##
	th[idx] = st_id(th[idx], pc - 1) if mx >= idx
	if [] != th[mx]
	  self.pl_es(pc, ['th', th])
#	  idx = idx == mx ? 0 : idx + 1	###
	  flg = true	##
	end
	Slp.new.slp 0
	Fiber.yield(flg && idx >= mx)	##
	idx += 1	##
      end
    }
##  self.lf_d
#   [0, th]	###
  end

  def plw(pc = 1)
#   cto = 0
#   ith = 0
#   th = []
    flg = true
    loop do
#     pc = self.ctr_g
      pc, cto = self.ctr_g if flg
      if pc != cto || ! flg
#	cto += 1
	f = self.pl(pc) if flg

#	an[cto] = Thread.new(envid) { |envid|
#	self.pl(cto)
#	self.pl(pc - 1)
#	(ith, th) = self.pl(pc, ith, th)
#	(flg = [true][ith] || false) || (Slp.new.slp 0; redo)
#	(flg = self.pl(pc)) || (Slp.new.slp 0; redo)
	(flg = f.resume) || (Slp.new.slp 0.0001; redo)
#	if flg
#	  ith = 0
#	else	
#	  redo
#	end
      end
      Slp.new.slp
#     sleep 0.002
#     sleep 0.00001
####  GC.start
    end
  end

# private
end

#class ENVary < Array
#  include M__ENVary
#end

module M__Stack
  def initialize(sp = 0)
#    @sp = [sp, sp]
#    @ofs = [0, 0]
  end
#  def []=(*a)
#    a = a.each { |v|}
##      case v.is_a?(String)
##    when true
#    sd = b.shift
#    @ofs[['S', 'D'].index(sd)] = b.first
##      case b.shift
##      when 'S'
##	@sp[0] = b.first
##      when 'D'
##	@sp[1] = b.first
##      end
##    else
#      super
##    end
#  end

  def ofs(*a)
    sd = a.shift
    @ofs[['S', 'D'].index(sd)] = a.first
  end

  def sp_g(sp = 0)
    @sp
  end
end

class Stack < Array
  include M__Stack
end

class FibVM
# include RiteOpcodeUtil
  OPTABLE_CODE = Irep::OPTABLE_CODE
  OPTABLE_SYM = Irep::OPTABLE_SYM
#   rmth = 63
#   rmth = 47
  @@rmth = 39

  def initialize
    @imem = Imem.new
    @flag = []

    # For Interpriter
#   @stack = []			# スタック(@spより上位をレジスタとして扱う)
    @stack = Stack.new		# スタック(@spより上位をレジスタとして扱う)
    @callinfo = []		# メソッド呼び出しで呼び出し元の情報を格納
    @pc = 0			# 実行する命令の位置
    @sp = 0			# スタックポインタ
    @cp = 0			# callinfoのポインタ
    @irep = [nil]		# 現在実行中の命令列オブジェクト
    @irepid =nil		# 命令列オブジェクトのid(JIT用)

    rmth = @@rmth
#   @pla = Array.new($pcmax)
#   $pltini.call()
    thini = [false, 0]
    @pl = ENVary.new(rmth + 1, [thini], [], [])

    plini


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
    # 3080410200 : 5x2 ok ( gc ) : monami-ya.mrb 8270410200 813e2af8	# http://www.monami-ya.jp/
    @pl[0] = [['th',  'sym', 'ctr', 'cto'],	# mruby 20410200 : higokan ? : ary_many
	      [[thini],  0,    [0],   [0]]]	# mruby 70410200 : 4x2 ok , 5x2 ng

    @pla = [['sp_r', 'ctr']]

#   (1..$pcmax + 1).each{ |n| @pl[n] = Envha.new(n, {})}
#     @pl = [$pcmax + 1, {}]
#     @envid = @pl.gethd

#     @@wa.each{ |v|
#     @@idx[v] = wa.index(v)
##    eval "v = wa.index(v)"
#   }
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

  def rslt(pl)
    r = pl[@pl.affil('th', 'i')]
    r[1] = r[-1]
    [pl[@pl.affil('sym', 'i')].to_sym, r]
  end

  def fls(pc, pl = [])
#    return if 0 != @flag[0]

    ppll = @pl
    i_th = ppll.affil('th', 'i')
    plspr = pl[ppll.affil(@pla.assoc('sp_r')[1], 'i')]
    sp = plspr[0]

    flg = [false]
    s = @stack
    i = @irep[0]
    r0, r1 = [0, 0]
    fml = [
      [:MOVE,     lambda {s[r0]}],         [:LOADL,   lambda {i.pool[r0]}],
      [:LOADI,    lambda {  r0 }],         [:LOADSYM, lambda {i.syms[r0]}],
      [:LOADSELF, lambda {s[r0]}],         [:LOADT,   lambda {       r0 }],
      [:ADD,      lambda {s[r0 + 1]}, :+], [:ADDI,    lambda {       r0 }, :+],
      [:SUB,      lambda {s[r0 + 1]}, :-], [:SUBI,    lambda {       r0 }, :-],
      [:MUL,      lambda {s[r0 + 1]}, :*], [:DIV,     lambda { s[1 + r0]}, :/],
      [:EQ,       lambda {s[r1] == s[r0 + 1]}]
    ]
#   when :MOVE
#     @stack[@sp + getarg_a(cop)] = @stack[@sp + getarg_b(cop)]
#     stack_s(stack_g(r0), r1)
#     @stack[r1] = @stack[r0]
#   when :LOADL
#     @stack[@sp + getarg_a(cop)] = @irep.pool[getarg_bx(cop)]
#     stack_s(@irep[0].pool[r0], r1)
#     @stack[r1] = @irep[0].pool[r0]
#   when :LOADI
#     @stack[@sp + getarg_a(cop)] = getarg_sbx(cop)
#     stack_s(r0, r1)
#     @stack[r1] = r0
#   when :LOADSYM
#     @stack[@sp + getarg_a(cop)] = @irep.syms[getarg_bx(cop)]
#     @stack[r1] = @irep[0].syms[r0]
#   when :LOADSELF
#     @stack[@sp + getarg_a(cop)] = @stack[@sp]
#     @stack[r1] = @stack[r0]
#   when :LOADT
#     @stack[@sp + getarg_a(cop)] = true
#     @stack[r1] = r0
#   when :ADD
#     @stack[@sp + getarg_a(cop)] += @stack[@sp + getarg_a(cop) + 1]
#     stack_s(stack_g(r0 + 1), r1, :+)
#     @stack[r1] += @stack[r0 + 1]
#   when :ADDI
#     @stack[@sp + getarg_a(cop)] += getarg_c(cop)
#     stack_s(r0, r1, :+)
#     @stack[r1] += r0
#   when :SUB
#     @stack[@sp + getarg_a(cop)] -= @stack[@sp + getarg_a(cop) + 1]
#     @stack[r1] -= @stack[r0 + 1]
#   when :SUBI
#     @stack[@sp + getarg_a(cop)] -= getarg_c(cop)
#     @stack[r1] -= r0
#   when :MUL
#     @stack[@sp + getarg_a(cop)] *= @stack[@sp + getarg_a(cop) + 1]
#     @stack[r1] *= @stack[r0 + 1]
#   when :DIV
#     @stack[@sp + getarg_a(cop)] /= @stack[@sp + getarg_a(cop) + 1]
#     @stack[r1] /= @stack[r0 + 1]
#   when :EQ
#     val = (@stack[@sp + getarg_a(cop)] == @stack[@sp + getarg_a(cop) + 1])
#     @stack[@sp + getarg_a(cop)] = val
#     val = stack_g(r1) == stack_g(r0 + 1)
#     val = @stack[r1] == @stack[r0 + 1]
#     @stack[@sp + getarg_a(cop)] = val
#     stack_s(val, r1)
#     @stack[r1] = val



    for idx in (0 ... pl[i_th].size)
      flg[idx] = ppll.ckth(pl[i_th][idx], 1)
    end

    sym, r = rslt(pl)
    r0, r1 = r

# p "#{(pc - 1).to_xeh} #{sym} #{r1.to_xeh} #{r0.to_xeh}"

    pr, sy = fml.assoc(sym)[1 .. -1]
    p = Proc.new { |r0, r1| r1 && pr.call}

    rs = ['-', '-']
    wd = plspr.width
    if flg[0] && flg[-1]
      r00 = (plspr[r1 + 1] if 0 < wd && r1 < wd) || p.(r0, r1)	# c 
      r00 = [s[r1], r00].inject(sy) if nil != sy
      s[r1] = r00
      rs = [r1.to_xeh, r0.to_xeh]
    elsif flg[0]
#      0xf.times { |n|
      wd.step(wd + 0xe) { |n|
#	r00 = nil == r1 ? r1 : p.(r0, r1)	# c 
#	plspr.push(p.(r0, s[wd + n]))		# c
	plspr<< p.(r0, s[n])		# p # c 
      }
      rs[1] = r0.to_xeh
    elsif flg[-1]
      rs[0] = r1.to_xeh
    end
print "#{(pc - 1).to_xeh}			#{sym}	#{rs[1]}	#{rs[0]}\n"
#   pl
    return([! flg.include?(false), pl])
  end

  def iset(sym, cop, sp, pc)
    pc1 = pc + 1
    imem = @imem
    pl = @pl
#   i_lf = @idx['lf']

      # 何もしない
#   when :NOP
      # MOVE Ra, RbでレジスタRaにレジスタRbの内容をセットする
#   when :MOVE
#     @stack[@sp + getarg_a(cop)] = @stack[@sp + getarg_b(cop)]
      # LOADL Ra, pb でレジスタRaに定数テーブル(pool)のpb番目の値をセットする
#   when :LOADL
#     @stack[@sp + getarg_a(cop)] = @irep.pool[getarg_bx(cop)]
#     ops = [[['getarg_bx', cop], [sp, ['getarg_a', cop]]]]
      # LOADI Ra, n でレジスタRaにFixnumの値 nをセットする
#   when :LOADI
#     @stack[@sp + getarg_a(cop)] = getarg_sbx(cop)
#   when :LOADSYM
#     @stack[@sp + getarg_a(cop)] = irep.syms[getarg_bx(cop)]
      # LOADSELF Ra でレジスタRaに現在のselfをセットする
#   when :LOADSELF
#     @stack[@sp + getarg_a(cop)] = @stack[@sp]
#     ops = [[[sp], [sp, ['getarg_a', cop]]]]
#   when :LOADT
#     @stack[@sp + getarg_a(cop)] = true
      # ADD Ra, Rb でレジスタRaにRa+Rbをセットする
#   when :ADD
#     @stack[@sp + getarg_a(cop)] += @stack[@sp + getarg_a(cop) + 1]
#     ops = [[[sp, ['getarg_a', cop]]]]
#   when :ADDI
#     @stack[@sp + getarg_a(cop)] += getarg_c(cop)
#   when :SUB
#     @stack[@sp + getarg_a(cop)] -= @stack[@sp + getarg_a(cop) + 1]
      # SUB Ra, n でレジスタRaにRa-nをセットする
#   when :SUBI
#     @stack[@sp + getarg_a(cop)] -= getarg_c(cop)
#   when :MUL
#     @stack[@sp + getarg_a(cop)] *= @stack[@sp + getarg_a(cop) + 1]
#   when :DIV
#     @stack[@sp + getarg_a(cop)] /= @stack[@sp + getarg_a(cop) + 1]
      # EQ Ra でRaとR(a+1)を比べて同じならtrue, 違うならfalseをRaにセットする
#   when :EQ
#     val = (@stack[@sp + getarg_a(cop)] == @stack[@sp + getarg_a(cop) + 1])
#     @stack[@sp + getarg_a(cop)] = val

    ops = [
      [:MOVE,     [[1, 'getarg_b'],   [1]]], [:LOADL,   [[0, 'getarg_bx'], [1]]],
      [:LOADI,    [[0, 'getarg_sbx'], [1]]], [:LOADSYM, [[0, 'getarg_bx'], [1]]],
      [:LOADSELF, [[1],               [1]]], [:LOADT,   [[0, true],        [1]]],
      [:ADD,      [[1]]],                    [:ADDI,    [[0, 'getarg_c'],  [1]]],
      [:SUB,      [[1]]],                    [:SUBI,    [[0, 'getarg_c'],  [1]]],
      [:MUL, [[1]]], [:DIV, [[1]]], [:EQ, [[1]]]
    ]
    fml = ops.assoc(sym) || (
      printf("Unkown code %s \n", OPTABLE_SYM[imem.get_opcode(cop)])
      return
    )

    ta = lambda { |lth|
      lsp = sp >> ((1 - lth.shift) << 8)	# 256
      th = [lth.pop || 'getarg_a', cop]
      th = [lsp, th] if 0 != lsp
      th
    }
#    ops = []
#    ops.push fml.shift
   ops = ['sym', fml.shift] #, 'th']
#    for idx in (0 ... fml.size)
#      ths = []
      ths = fml.shift
#      lith = 0
#      ths.push(ta.(fml[idx][lith]), [])	# c
      ops.push('th', [ta.(ths.shift), []])	# c 
#      ops.push ths
#    end
#    ops.push [sp]
    ops.push(@pla.assoc('sp_r')[1], [sp])

#    pl.pl_es(pc1, ['sym', 'th', @pla.assoc('sp_r')[1]].flat_map { |o| [o].push(ops.shift)})
    pl.pl_es(pc1, ops)
####    pl.ctr_s(pc1)

    Slp.new.slp 0
    th = pl.pl_eg(pc1, 'th')
#    if 1 < fml[idx].size
    if 0 < ths.size
#      lith = 1
#      ths[lith] = ta.(fml[idx][lith])	# c
      th[-1] = ta.(ths.shift)		# c 
    else
      th.delete_at(1)
    end
    pl.pl_es(pc1, ['th', th])
    pl.ctr_s(pc1)

#   pl1[i_ctr] += 1
#   pl1[i_lf] += 1
  end

  def opf(irep, pc)
    imem = @imem

    #　命令コードの取り出し
#   cop = @irep.iseq[@pc]
    cop = irep.iseq[pc]

#   case OPTABLE_SYM[get_opcode(cop)]
#   sym = OPTABLE_SYM[get_opcode(cop)]
#   sym = OPTABLE_SYM[ppll.get_opcode(cop)]
    sym = OPTABLE_SYM[imem.get_opcode(cop)]
    [cop, sym]
  end

  def eval(irep)
    ppll = @pl
    imem = @imem

    @irep[0] = irep
#   @irepid = @irep.id
    @irepid = irep.id

    i_th = ppll.affil('th', 'i')

    @flag[0] = 1

    flg = Array.new(@@rmth + 1) {true}
    while true
      if flg[0]
	pc = @pc
	sp = @sp ##

	cop, sym = opf(irep, pc)
#print "#{pc.to_xeh}	#{sym}	#{cop}"
print "#{pc.to_xeh}	#{sym}	#{cop.to_xeh}\n"

	pl = ppll.pl_g(pc)
      else
	pl[i_th] = ppll.pl_eg(pc, 'th')
      end

#      if 0 == @flag[0] and 0 != pc
#	flg[0] = true
#	pl[i_th].each { |v| if ! ppll.ckth(v, 1) then flg[0] = false; break end}
#      end

#      pl = fls(pc, pl)
      flg[0], pl = fls(pc, pl) if 0 == @flag[0]

      if flg[0]

	if 'J' != sym.to_s[0] and ! [:ENTER, :SEND, :RETURN].include?(sym)
	  iset(sym, cop, sp, pc)
	else

#	  while ! ppll.ctr_c do Slp.new.slp end

	  plini
	  @flag[0] = 2

	  case sym

	    # JMP nでpcをnだけ増やす。ただし、nは符号付き
	  when :JMP
##	    @pc = @pc + getarg_sbx(cop)
#	    pc = pc + ppll.getarg_sbx(cop) - 1
	    pc = pc + imem.getarg_sbx(cop) - 1
##	    next

	  when :JMPIF
#	    if @stack[@sp + getarg_a(cop)] then
#	    if @stack[sp + ppll.getarg_a(cop)] then
	    if @stack[sp + imem.getarg_a(cop)] then
#	      @pc = @pc + getarg_sbx(cop)
#	      pc = pc + ppll.getarg_sbx(cop) - 1
	      pc = pc + imem.getarg_sbx(cop) - 1
#	      next
	    end

	    # JMPNOT Ra, nでもしRaがnilかfalseならpcをnだけ増やす。ただし、nは符号付き
	  when :JMPNOT
###	    if !@stack[@sp + getarg_a(cop)] then
#	    if !@stack[sp + ppll.getarg_a(cop)] then
	    if !@stack[sp + imem.getarg_a(cop)] then
##	      @pc = @pc + getarg_sbx(cop)
#	      pc = pc + ppll.getarg_sbx(cop) - 1
	      pc = pc + imem.getarg_sbx(cop) - 1
##	      next
	    end

	    # メソッドの先頭で引数のセットアップする命令。面倒なので詳細は省略
	  when :ENTER

	    # SEND Ra, mid, anumでRaをレシーバにしてシンボルmidの名前のメソッドを
	    # 呼び出す。ただし、引数はanum個あり、R(a+1), R(a+2)... R(a+anum)が引数
	  when :SEND
#	    a = getarg_a(cop)
#	    a = ppll.getarg_a(cop)
	    a = imem.getarg_a(cop)
#	    mid = @irep.syms[getarg_b(cop)]
#	    mid = irep.syms[ppll.getarg_b(cop)]
	    mid = irep.syms[imem.getarg_b(cop)]
#	    n = getarg_c(cop)
#	    n = ppll.getarg_c(cop)
	    n = imem.getarg_c(cop)
###	    newirep = Irep::get_irep(@stack[@sp + a], mid)
	    newirep = Irep::get_irep(@stack[sp + a], mid)
	    if newirep then
###	      @callinfo[@cp] = @sp
	      @callinfo[@cp] = sp
	      @cp += 1
#	      @callinfo[@cp] = @pc
	      @callinfo[@cp] = pc
	      @cp += 1
#	      @callinfo[@cp] = @irep
	      @callinfo[@cp] = irep
	      @cp += 1
###	      @sp += a
	      sp += a
##	      @pc = 0
	      pc = -1
#	      @irep = newirep
	      irep = newirep
#	      @irepid = @irep.id
	      @irepid = irep.id

##	      next
	    else
	      args = []
	      n.times do |i|
###	        args.push @stack[@sp + a + i + 1]
		args.push @stack[sp + a + i + 1]
	      end

###	      @stack[@sp + a] = @stack[@sp + a].send(mid, *args)
	      @stack[sp + a] = @stack[sp + a].send(mid, *args)
	    end

	    # RETURN Raで呼び出し元のメソッドに戻る。Raが戻り値になる
	  when :RETURN
	    if @cp == 0 then
###	      return @stack[@sp + getarg_a(cop)]
#	      return @stack[sp + ppll.getarg_a(cop)]
	      return @stack[sp + imem.getarg_a(cop)]
	    else
###	      @stack[@sp] = @stack[@sp + getarg_a(cop)]
#	      @stack[sp] = @stack[sp + ppll.getarg_a(cop)]
	      @stack[sp] = @stack[sp + imem.getarg_a(cop)]
	      @cp -= 1
#	      @irep = @callinfo[@cp]
	      irep = @callinfo[@cp]
#	      @irepid = @irep.id
	      @irepid = irep.id
	      @cp -= 1
###	      @pc = @callinfo[@cp]
	      pc = @callinfo[@cp] - 1
	      @cp -= 1
###	      @sp = @callinfo[@cp]
	      sp = @callinfo[@cp]
	    end
#	  else
##	    printf("Unkown code %s \n", OPTABLE_SYM[get_opcode(cop)])
#	    printf("Unkown code %s \n", OPTABLE_SYM[imem.get_opcode(cop)])
	  end
	end

	@flag[0] >>= 1
	@pc = pc + 1
	@sp = sp ##
	@irep[0] = irep

      else
	Slp.new.slp
      end	# if flg
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
