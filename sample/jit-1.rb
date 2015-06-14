# -*- coding: iso-2022-jp -*-

module M__Object
# def mapr(&b)
#   knid(self, 'Array') ? self.map { |v| v.__method__ b} : yield(self)
# end
# def mapr(a, &b)
#   a.map { |v| knid(v, 'Array') ? __method__(v, b) : yield(v)}
# def mapr(&b)
#   self.map { |v| knid(v, 'Array') ? v.__method__(b) : yield(v)}

  def to_i_from(k, i = 0)
#   self.is_a?(k) ? i + self.to_i : self	# unwork ? ( thread ? ) # mrblib/
#   knid(k, self) ? i + self.to_i : self	# unwork ? ( thread ? ) # mrblib/
    self.class.to_s == k.to_s ? i + self.to_i : self	# unwork ? ( thread ? ) # mrblib/
  end

# def kind_of?(k)
##  self.class == k.class
#   self.kind_of?(k)	# unwork ? ( thread ? )
# end

  KS = (0 .. 9).to_a.join + '-'	# * '' higokan mruby 70410200	# '0'.upto # higokan mruby 70410200 # 7221410200 6ccae658 suzukaze
#  TP = [['Array',  -> {Class::Array }], ['Numeric', -> {Class::Numeric}],
#	['Fixnum', -> {Class::Fixnum}], ['Float',   -> {Class::Float  }],
#	['String', -> {Class::String}]]	# .lazy
  def knid(v, k)
#   k = Kernel.const_get k
#    return v.kind_of?(TP.assoc(k)[1].call) if 0.kind_of?(Numeric)	# super
#   return v.kind_of?(TP.force.assoc(k)[1].call) if 0.kind_of?(Numeric)	# super
#   return v.kind_of?(Object.const_get k) if 0.kind_of?(Numeric)	# super
    return v.kind_of?(Kernel.const_get k) if 0.kind_of?(Numeric)	# super
#   return v.kind_of?(k.constantize) if 0.kind_of?(Numeric)	# RoR	# super

    if v == vs = v.to_s
      'String' == k	# String
    else
#   elsif false != v
#     case k
      ! ! case k
      when 'Array'	# , Array
	'[]' == vs[0] + vs[-1]
      when 'Numeric', 'Fixnum', 'Float'	# , Numeric, Fixnum, Float
	s = KS + 'Fixnum' == k ? '' : '.'	# Fixnum
	vs.each_byte { |c| s.include?(c) || break}
#      end && true || false
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
# def ijr(&b)
#   yield self.map { |v| knid(v, 'Array') ? v.__method__(b) : v}
# end

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

module M__Imem
  include RiteOpcodeUtil

  def initialize
    @fml = ->(lb) { [	# l 
      ['st',
	[:MOVE,     :s__sr0],	   [:LOADL,   :s__i_pool_r0],
	[:LOADI,    :s__r0 ],	   [:LOADSYM, :s__i_syms_r0],
	[:LOADSELF, :s__sr0],	   [:LOADT,   :s__r0],
	[:ADD,	    :s__sr01, :+], [:ADDI,    :s__r0,  :+],
	[:SUB,	    :s__sr01, :-], [:SUBI,    :s__r0,  :-],
	[:MUL,	    :s__sr01, :*], [:DIV,     :s__r01, :/],
	[:EQ,	    :s__r1_eq_sr01]],
      ['th',
	['bt', ['sym', true, 'th', true], ['sym', false, 'th', true]],
	[:MOVE,     [['getarg_b'    ], []]], [:LOADL,	[['getarg_bx'], []]],
	[:LOADI,    [['getarg_sbx'  ], []]], [:LOADSYM, [['getarg_bx'], []]],
	[:LOADSELF, [['mk_opcode', 0], []]], [:LOADT,	[[true, '', 0], []]],	# mk_opcode 0
	[:ADD,	    [[] 		 ]], [:ADDI,	[['getarg_c' ], []]],
	[:SUB,	    [[]			 ]], [:SUBI,	[['getarg_c' ], []]],
	[:MUL, [[]]], [:DIV, [[]]], [:EQ, [[]]]
      ]].assoc(lb) # .lazy
    }
  end

      # 何もしない
#   when :NOP
      # MOVE Ra, RbでレジスタRaにレジスタRbの内容をセットする
#   when :MOVE
#     @stack[@sp + getarg_a(cop)] = @stack[@sp + getarg_b(cop)]
#     @stack[r1] = @stack[r0]
      # LOADL Ra, pb でレジスタRaに定数テーブル(pool)のpb番目の値をセットする
#   when :LOADL
#     @stack[@sp + getarg_a(cop)] = @irep.pool[getarg_bx(cop)]
#     @stack[r1] = @irep[0].pool[r0]
#     ops = [[['getarg_bx', cop], [sp, ['getarg_a', cop]]]]
      # LOADI Ra, n でレジスタRaにFixnumの値 nをセットする
#   when :LOADI
#     @stack[@sp + getarg_a(cop)] = getarg_sbx(cop)
#     @stack[r1] = r0
#   when :LOADSYM
#     @stack[@sp + getarg_a(cop)] = irep.syms[getarg_bx(cop)]
#     @stack[r1] = @irep[0].syms[r0]
      # LOADSELF Ra でレジスタRaに現在のselfをセットする
#   when :LOADSELF
#     @stack[@sp + getarg_a(cop)] = @stack[@sp]
#     @stack[r1] = @stack[r0]
#     ops = [[[sp], [sp, ['getarg_a', cop]]]]
#   when :LOADT
#     @stack[@sp + getarg_a(cop)] = true
#     @stack[r1] = r0
      # ADD Ra, Rb でレジスタRaにRa+Rbをセットする
#   when :ADD
#     @stack[@sp + getarg_a(cop)] += @stack[@sp + getarg_a(cop) + 1]
#     @stack[r1] += @stack[r0 + 1]
#     ops = [[[sp, ['getarg_a', cop]]]]
#   when :ADDI
#     @stack[@sp + getarg_a(cop)] += getarg_c(cop)
#     @stack[r1] += r0
#   when :SUB
#     @stack[@sp + getarg_a(cop)] -= @stack[@sp + getarg_a(cop) + 1]
#     @stack[r1] -= @stack[r0 + 1]
      # SUB Ra, n でレジスタRaにRa-nをセットする
#   when :SUBI
#     @stack[@sp + getarg_a(cop)] -= getarg_c(cop)
#     @stack[r1] -= r0
#   when :MUL
#     @stack[@sp + getarg_a(cop)] *= @stack[@sp + getarg_a(cop) + 1]
#     @stack[r1] *= @stack[r0 + 1]
#   when :DIV
#     @stack[@sp + getarg_a(cop)] /= @stack[@sp + getarg_a(cop) + 1]
#     @stack[r1] /= @stack[r0 + 1]
      # EQ Ra でRaとR(a+1)を比べて同じならtrue, 違うならfalseをRaにセットする
#   when :EQ
#     val = (@stack[@sp + getarg_a(cop)] == @stack[@sp + getarg_a(cop) + 1])
#     val = @stack[r1] == @stack[r0 + 1]
#     @stack[@sp + getarg_a(cop)] = val
#     @stack[r1] = val  end

  def fml(lb, sym)
    @fml.(lb).assoc(sym)	# c 
  end

#  @@i_s__i = 0; @@i_s__s = 1; @@i_s__r0 = 2; @@i_s__r1 = 3

#  def s__sr0(	    *a) a[@@i_s__s][	 a[@@i_s__r0]]	   end
#  def s__r0(	    *a) 		 a[@@i_s__r0]	   end
#  def s__sr01(	    *a) a[@@i_s__s][	 a[@@i_s__r0] + 1] end
#  def s__i_pool_r0( *a) a[@@i_s__i].pool[a[@@i_s__r0]]	   end
#  def s__i_syms_r0( *a) a[@@i_s__i].syms[a[@@i_s__r0]]	   end
#  def s__r1_eq_sr01(*a) a[@@i_s__s][	 a[@@i_s__r1]] == a[@@i_s__s][a[@@i_s__r0] + 1] end

  @@I_s__i = 0; @@I_s__s = 1; @@I_s__r0 = 2; @@I_s__r1 = 3

  def s__sr0(	    *a) a[@@I_s__s][	 a[@@I_s__r0]]	   end
  def s__r0(	    *a) 		 a[@@I_s__r0]	   end
  def s__sr01(	    *a) a[@@I_s__s][	 a[@@I_s__r0] + 1] end
  def s__i_pool_r0( *a) a[@@I_s__i].pool[a[@@I_s__r0]]	   end
  def s__i_syms_r0( *a) a[@@I_s__i].syms[a[@@I_s__r0]]	   end
  def s__r1_eq_sr01(*a) a[@@I_s__s][	 a[@@I_s__r1]] == a[@@I_s__s][a[@@I_s__r0] + 1] end

  def mcall(*op)
    knid(op[0], 'Numeric') ? op.inject(:+) : self.send(*op)
  end
end

class Imem
  include M__Imem
end

# module M__ENVary	# higokan ? mruby 70410200
class ENVary < Array
# include RiteOpcodeUtil

# @imem = Imem.new	# higokan mruby 80410200
  @@Imem = Imem.new

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

  def plini
    thini = false

    # 3080410200 : gene gc off : mruby 6170410200 d17506c1
    # 3080410200 : 5x2 ng ( segmentation fault ) : mruby 3080410200 0878900f
    # 3080410200 : 5x2 ok ( gc ) : monami-ya.mrb 8270410200 813e2af8	# http://www.monami-ya.jp/
#    @pl[0] = [['th',  'sym', 'ctr', 'cto'],	# mruby 20410200 : higokan ? : ary_many
    self[0] = [['th',  'sym', 'ctr', 'cto'],	# mruby 20410200 : higokan ? : ary_many
	      [[thini],  0,    [0],   [0]]]	# mruby 70410200 : 4x2 ok , 5x2 ng

#    @pla ||= [['sp_r', 'ctr']]
##   @plb ||= (@pla.dup).map { |a| a[1] = @pl.affil(a[1], 'i'); a}	# higokan ? mruby 70410200
#    @plb ||= @pla.map { |a| [a[0], @pl.affil(a[1], 'i')]}
  end


# @@ploc = Fiber.new { |a|
# @@ploc = Proc.new { |*a|
  def ploc(*a)
#   @m.lock
    begin
      f = File.open(@@fl, 'w')
      f.flock(File::LOCK_EX)
    rescue
      Slp.new.slp 0
      retry
    end
#    r = true
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
#   t > n ? n + 1 : n
    n + (t > n ? 1 : 0)
#   n + [false, true].index(t > n)
#   n + (((t > n) && 1) || 0)
#   n + (t > n && 1 || 0)
#   n + ((t <=> n) & 1)[0]		# higokan mruby 70410200
#   n + (((t <=> n) + 1) & 2)[1]	# higokan mruby 70410200
#   n + ((((t <=> n) + 1) & 2) >> 1)
  end

# @@fxnm = nil
  def pl_g(n = 0)
#   sleep 0; GC.start; sleep 0
#   self[n < 0 ? n + 1 : n][self.idx0(n)]
    pl = self[self.idx0(n, 0)]
#   1 > n ? pl[self.idx0(n)] : pl
    if 1 > n
      pl = pl[self.idx0(n)]
#     (nil == @@fxnm) && @@fxnm = (Float == self.affil('ctr')[0].class)
#     (nil == @@fxnm) && @@fxnm = (Float == self.ctr_r.class)
    end
#   pl = pl.mapr { |v| v.to_i_from(Numeric)} if @@fxnm	# furui mattn/mruby-json
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
    ary.each_slice(2) { |k, v| pl[self.affil(k, 'i')] = v}	# memo .shift(2) higokan mruby 70410200
    pl_s(n, pl)
  end

  def ctr_g
#    ctr, cto = [pl_eg('ctr')[0], pl_eg('cto')[0]]
    ctr, cto = [ctr_r, cto_r]
    cto_s(ctr) if ctr != cto
    [ctr, cto]
  end

  def ctr_r
    pl_eg('ctr')[0]
  end

  def cto_r
    pl_eg('cto')[0]
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
    (knid(th, 'Array') ? 0 : 1) == md
#   knid(th, 'Array') == [true, false][md]
  end

  def st_id(a, pc)
#   return a if [] == a or ! knid(a, 'Array')
    return a if [] == a || ! knid(a, :Array)	# t 
#    a = a.map { |v|
    a.map! { |v|
##    v.kind_of?(Array) ? __send__(v, pc) : v	# unwork ( thread ? )
#     knid(v, 'Array') ? __method__(v, pc) : v	# unwork ( thread ? )
#     knid(v, 'Array') ? __callee__(v, pc) : v	# unwork ( thread ? )
      knid(v, 'Array') ? st_id(v, pc) : v
    }
    return a[0] if 2 > a.size
#   return a.ijr { |v| v.inject(@@imem.mcall) || v[0]}

#   GC.start
    a.inject { |opc, op|
print "#{pc.to_xeh}		#{opc}	#{op.to_xeh}\n" if ! knid(opc, 'Numeric')
#      @@Imem.mcall(opc, op) || op
      (imem = @@Imem).mcall(opc, op) || op
    }
  end

# def pl(pc, idx, th)	###
  def plw(pc)	##
#   i_th = self.affil('th', 'i')	# # higokan mruby 10410200 ( irep.rb )
#   i_lf = self[0].index('lf')
#    th = []	##
#    idx = 0	##
    th = []; idx = 0	##
    flg = false
#   mx = nil
    Fiber.new {	##
#   th[idx .. -1] = (thn = pl_eg(pc, 'th'))[idx .. -1]	###
      while th[idx .. -1] = (thn = pl_eg(pc, 'th'))[idx .. -1]	##
#	th = th[0 .. (mx = thn.width)]	####
	mx = thn.width
#	mx ||= thn.width
#	flg = false	##
	th[idx] = st_id(th[idx], pc - 1)
	if [] != th[mx]		# t 
	  self.pl_es(pc, ['th', th])
#	  idx = idx == mx ? 0 : idx + 1	###
#	  flg = true	##
	  flg ||= ckth(th[mx], 1)
	end
	Slp.new.slp 0
#	Slp.new.slp(0, 4096)
	Fiber.yield(flg && idx >= mx)	##
	idx += 1 if idx < mx || [] != th[mx]	# t 	##
####	idx += 1 if idx < mx && [] != th[mx]	# t 	# fuguai taisaku	##
      end
    }
##  self.lf_d
#   [0, th]	###
  end

#  def plw(pc = 1)
  def plm(pc = 1)
    flg = true
    loop do
#     pc = self.ctr_g
      pc, cto = self.ctr_g if flg
      if pc != cto || ! flg
#	cto += 1
#	f = self.pl(pc) if flg
	f = self.plw(pc) if flg

#	an[cto] = Thread.new(envid) { |envid|
#	self.pl(cto)
#	self.pl(pc - 1)
#	(ith, th) = self.pl(pc, ith, th)	###
#	(flg = [true][ith] || false) || (Slp.new.slp 0; redo)	###
#	(flg = f.resume) ? f = nil : (Slp.new.slp 0; redo)	##
	if ! (flg = f.resume) then Slp.new.slp 0; redo end	##
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

#class Sp # < Numeric
#  @@sp = []
#  def initialize(sp = 0)
#    @@sp = sp
#  end
#end

module M__Stack
  @@s = []
  @@m = Mutex.new

#  def initialize(sp = 0)
  def initialize(sp = 0, s = @@s)
#   p id = self.object_id
    @s = s
    @p = sp

#   @@m.lock
##     s = @@s # .dup
#     s = @s
#   @@m.unlock
#    @@s
    @s
#   s
  end

  def sp(*a)
#   p id = self.object_id
    @p = a[0] if 0 < a.size
    @p
  end

  def [](*a)
#    @@m.lock
#      s = @@s # .dup
#      s = @s
#    @@m.unlock
##    @@stack[a[0] + self.sp]
#    s[a[0] + @p]
#    @@s[a[0] + @p]
    @s[a[0] + @p]
  end

  def []=(*a)
#   sp = @p + a[0]
#   a = a[1]
#   @@m.lock
##      a = @@stack[sp] = a
#      a = @@s[sp] = a
##     @@stack[sp] = a
#      a = @@s[a[0] + @p] = a[1]
#      a = @s[a[0] + @p] = a[1]
#   @@m.unlock
#   a
#    @@stack[@sp + a[0]] = a[1]
#    @@s[@sp + a[0]] = a[1]
    @s[@p + a[0]] = a[1]
  end
end

class Stack # < Array
  include M__Stack
end

class FibVM
# include RiteOpcodeUtil,
  (
    OPTABLE_CODE = Irep::OPTABLE_CODE
    OPTABLE_SYM = Irep::OPTABLE_SYM
#     rmth = 63
#     rmth = 47
    @@rmth = 39
  )

  def initialize
    @Imem = Imem.new
    @flag = []

    # For Interpriter
#   @stack = []			# スタック(@spより上位をレジスタとして扱う)
    @stack = Stack.new		# スタック(@spより上位をレジスタとして扱う)
    @callinfo = []		# メソッド呼び出しで呼び出し元の情報を格納
    @pc = 0			# 実行する命令の位置
    @sp = 0			# スタックポインタ
    @cp = 0			# callinfoのポインタ
#    @irep = [nil]		# 現在実行中の命令列オブジェクト
    @irep = nil			# 現在実行中の命令列オブジェクト
    @irepid =nil		# 命令列オブジェクトのid(JIT用)

    rmth = @@rmth
#   @pla = Array.new($pcmax)
#   $pltini.call()
    thini = [false, 0]
    @pl = ENVary.new(rmth + 1, [thini], [], [])

#    plini
    @pl.plini
    @pla = [['sp_r', 'ctr']]
#   @plb = (@pla.dup).map { |a| a[1] = @pl.affil(a[1], 'i'); a}	# higokan ? mruby 70410200
    @plb = @pla.map { |a| [a[0], @pl.affil(a[1], 'i')]}


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

  def wkth(pc = 1)
#   Thread.new($pcmax) { |pcmax|
#   Thread.new(@pl, pc) { |pl, pc|	# @Imem, 
##     pl.plw(pc)
#     pl.plm(pc)
    Thread.new(pc) { |pc|
#      ENVary.new(0).plw(pc)
      ENVary.new(0).plm(pc)
    }
  end

  def rslt(pl)
    lpl = @pl
#    r = pl[lpl.affil('th', 'i')]
#    r[1] = r[-1]
    r = pl[lpl.affil('th', 'i')]; r[1] = r[-1]
    [pl[lpl.affil('sym', 'i')].to_sym, r]
  end

# def fls(pc, pl = [])	###
  def fls(pc)	##
##	  pl = lpl.pl_g(pc) ### fls
##	pl[i_th] = lpl.pl_eg(pc, 'th')	### fls
    (
#    lpl = @pl
#    plb = @plb
      lpl = @pl; plb = @plb
      imem = @Imem
      i_th = lpl.affil('th', 'i')
      i_sp_r = plb.assoc('sp_r')[1]	##
#     plr = pl[lpl.affil(@pla.assoc('sp_r')[1], 'i')]	###
#     sp = plr[0]	###

      s = Stack.new
#    sp = nil; plr = nil
#      s = Stack.new; sp = nil; plr = nil
      i = @irep

#      wd = nil; isr0 = nil; r0 = nil; r1 = nil; lm = nil; sy = nil
#     sp, wd, isr0, r0, r1, lm, sy = []		# higokan ? mruby 70410200
#     sp, wd, isr0, r0, r1, lm, sy = [nil]
#     sp, wd, isr0, r0, r1, lm, sy = [][0]
      sp, wd, isr0, r0, r1, lm, sy = nil
      plr = []
#      flg = [false]
      flg = [false, false]
      rs = ['-', '-']
    )

    ca = [
      -> {	# flg[0] && flg[-1]
#	r00 = (plr[r1 + 1] if 0 < wd && r1 < wd) || lm.(isr0, r1)	# c 
	r00 = (plr[r1] if 0 <= wd && r1 <= wd) || lm.(isr0, r1)	# c 
#	s[r1] = nil == sy ? r00 : [s[r1], r00].inject(sy)
	s[r1] = sy ? [s[r1], r00].inject(sy) : r00
	rs = [r1.to_xeh, r0.to_xeh]},
      -> {	# flg[0]
#	((sw = sp + wd) + 0xe).step(sw, -1) {	# higokan mruby 70410200	# bbab89e7 5211410200 tmtm
#	wd.step(sw ||= wd + 0xe) { |n| plr<< lm.(isr0, s[n])}; sw = nil	# p c 
	wd.step(wd + 0xe) { |n| plr<< lm.(isr0, s[n])}	# p c 
	rs[1] = r0.to_xeh},
      -> {	# flg[-1]
	rs[0] = r1.to_xeh},
      -> {}
    ]

    Fiber.new {
      loop do	##
	pl = lpl.pl_g(pc)	##
#	sp || s.sp(sp = (plr = pl[i_sp_r])[0])
#	sp ||= s.sp((plr = pl[i_sp_r])[0])
	sp ||= s.sp(pl[i_sp_r][0])

#	pl[i_th].each_with_index { |v, idx| flg[idx] = lpl.ckth(v, 1)}

#	sym, (r0, r1) = rslt pl	# higokan mruby 70410200	# bce75e27 2211410200 matz
	sym, r = rslt(pl); r0, r1 = r
	flg = r.map { |v| lpl.ckth(v, 1)}

	pr, sy = imem.fml('st', sym)[1 .. -1]
	lm ||= ->(isr0, r1) {r1 && imem.send(pr, *isr0, r1)}	# l 

	isr0 = [i, s, r0]
#	wd = plr.width
	flg[0] && wd = plr.width
	ca[flg.inject(0) { |rv, v| rv <<= 1; rv |= v ? 0 : 1}].call

print "#{(pc - 1).to_xeh}			#{sym}	#{rs[1]}	#{rs[0]}\n"
#	pl
#	return([! flg.include?(false), pl])	###
	Fiber.yield(! flg.include?(false))	##
      end	##
    }
  end

# def iset(sym, cop, sp, pc, thi = 0, th = [])	# t 	###
# def iset(sym, cop, sp, pc)	##
  def iset(rg)	##
    pc, sp, cop, sym = [rg.assoc('pc')[1], rg.assoc('sp')[1], rg.assoc('cop')[1], rg.assoc('sym')[1]]

    pc1 = pc + 1
    imem = @Imem
#    pl = @pl
#    pla = @pla
    pl = @pl; pla = @pla
#   i_lf = @idx['lf']

    fml = imem.fml('th', sym) || (
      printf("Unkown code %s \n", OPTABLE_SYM[imem.get_opcode(cop)])
      return
    )
    fmla = fml

    bt = imem.fml('th', 'bt')[1 .. -1]
    ta = ->(lth) {	# l 
      [lth.shift || 'getarg_a', lth.shift || cop][0 .. lth.pop || 1]
    }

    th = [] 	##
    wd = 1
    opg = ->(oi) {	# l 
      fml = fmla.dup
      lopa = []
      bt[oi].each_slice(2) { |k, v|
	fv = fml.shift
	if v # && knid(fv, 'Array')
	  if 'th' == k
	    if 0 == oi
	      fv = [fv[oi] = th[oi] = ta.(fv[oi]), []]		# c t 
	    else
#	      fv = th += [ta.(fv[oi])] if oi <= wd = fv.width	# c t 
###	      fv = th += [[], [fv[oi] && ta.(fv[oi])]][(wd = fv.width) + 1 <=> oi]	# t c 
##	      fv = th += [[], [fv[oi] && ta.(fv[oi])]][(wd = fv.width) - oi <=> -1]	# t c 
#	      fv = th += [[fv[oi] && ta.(fv[oi])], []][oi - (wd = fv.width) <=> 0]	# c t 
	      fv = th += [[fv[oi] && ta.(fv[oi])], []][		# c t 
		(oi <=> wd = fv.width) + 1 >> 1]
	    end
	  end
	  lopa.push(k, fv)
	end
      }
      lopa
    }

    thi = 0	##
    k_sp_r = pla.assoc('sp_r')[1]
    Fiber.new {
      loop do	##
	opa = opg.(thi)	# c 
	opa.push(k_sp_r, [sp]) if 0 == thi

	pl.pl_es(pc1, opa)
	pl.ctr_s(pc1) if 0 == thi

	Slp.new.slp 0

#	pl.pl_es(pc1, ['sym', 'th', k_sp_r].flat_map { |o| [o].push(ops.shift)})
#	pl1[i_lf] += 1

	if 0 != thi && wd <= thi then thi = -1 end
#	[thi + 1, th]	###
	Fiber.yield(thi += 1)	##
      end	##
    }
  end

  def opf(irep, pc)
    imem = @Imem

    #　命令コードの取り出し
#   cop = @irep.iseq[@pc]
    cop = irep.iseq[pc]

#   case OPTABLE_SYM[get_opcode(cop)]
#   sym = OPTABLE_SYM[get_opcode(cop)]
#   sym = OPTABLE_SYM[lpl.get_opcode(cop)]
    sym = OPTABLE_SYM[imem.get_opcode(cop)]
    [cop, sym]
  end

  def eval(irep)
    lpl = @pl
    imem = @Imem
#    rg = [['i', 'pc',      'sp',   'cop',   'sym'],
#	       ['pc', 0], ['sp'], ['cop'], ['sym']]
    rg = [['ctr', -1], ['pc', @pc], ['sp'], ['cop'], ['sym']]

#   @irep[0] = irep
    @irep = irep
#   @irepid = @irep.id
    @irepid = irep.id

    i_th = lpl.affil('th', 'i')

    @flag[0] = 1

    flg = Array.new(@@rmth + 1) {true}
    thi = 0
#   th = []	# t 	###

    while true
      if flg[0]
	if 1 > thi	##
#	  if 0 > rg.assoc('ctr')[1]
#	    pc = @pc
#	    rg.assoc('pc')[1] = @pc
	    rg.assoc('ctr')[1] = rg.assoc('ctr')[1].abs
#	  end
#	  sp = @sp
	  @stack.sp(rg.assoc('sp')[1] = @sp) # + 0

#	  cop, sym = opf(irep, pc)
	  rg.assoc('cop')[1], rg.assoc('sym')[1] = opf(irep, rg.assoc('pc')[1])

print "#{rg.assoc('pc')[1].to_xeh}	#{rg.assoc('sym')[1]}	#{rg.assoc('cop')[1].to_xeh}\n"

#	  fl = fls(pc) if 0 == @flag[0]	##
	  0 == @flag[0] && fl = fls(rg.assoc('pc')[1])	##
	end	##
#     else
      end


#     flg[0], pl = fls(pc, pl) if 0 == @flag[0]	###
      fl && (flg[0] = fl.resume) && fl = nil	##

      if flg[0] or 0 != thi
#	if 'J' != sym.to_s[0] and ! [:ENTER, :SEND, :RETURN].include?(sym)
#	if 'J' != rg.assoc('sym')[1][0]	# higokan mruby 70410200
	if 'J' != rg.assoc('sym')[1].to_s[0] && ! [:ENTER, :SEND, :RETURN].include?(rg.assoc('sym')[1])
#	  thi, th = iset(sym, cop, sp, pc, thi, th)	###
#	  ise = iset(sym, cop, sp, pc) if 0 == thi	##
	  ise ||= iset(rg)	##
	  [true][thi = ise.resume] && ise = nil	##
#	  [true][thi = (ise ||= iset(rg)).resume] && ise = nil	##	# higokan ? mruby 70410200

	  rg.assoc('pc').push rg.assoc('pc')[1] if 0 == thi	##
	  pcn = rg.assoc('pc')[1] if 0 == thi	##

	else
	  rg.assoc('pc').push rg.assoc('pc')[1]

#	  while ! lpl.ctr_c do Slp.new.slp end

#	  plini
	  lpl.plini
	  @flag[0] = 2


	  case rg.assoc('sym')[1]

	    # 何もしない
	  when :NOP

	    # JMP nでpcをnだけ増やす。ただし、nは符号付き
	  when :JMP
#	    @pc = @pc + getarg_sbx(cop)
#	    pc = pc + lpl.getarg_sbx(cop) - 1
#	    pc = pc + imem.getarg_sbx(rg.assoc('cop')[1]) - 1
#	    rg.assoc('pc')[1] += imem.getarg_sbx(rg.assoc('cop')[1]) - 1
	    rg.assoc('pc')[-1] = rg.assoc('pc')[1] + imem.getarg_sbx(rg.assoc('cop')[1]) - 1
#	    next

	  when :JMPIF
#	    if @stack[@sp + getarg_a(cop)] then
#	    if @stack[sp + lpl.getarg_a(cop)] then
	    if @stack[imem.getarg_a(rg.assoc('cop')[1])] then
#	      @pc = @pc + getarg_sbx(cop)
#	      pc = pc + lpl.getarg_sbx(cop) - 1
#	      pc = pc + imem.getarg_sbx(rg.assoc('cop')[1]) - 1
#	      rg.assoc('pc')[1] += imem.getarg_sbx(rg.assoc('cop')[1]) - 1
	      rg.assoc('pc')[-1] = rg.assoc('pc')[1] + imem.getarg_sbx(rg.assoc('cop')[1]) - 1
#	      next
	    end

	    # JMPNOT Ra, nでもしRaがnilかfalseならpcをnだけ増やす。ただし、nは符号付き
	  when :JMPNOT
#	    if !@stack[@sp + getarg_a(cop)] then
#	    if !@stack[sp + lpl.getarg_a(cop)] then
	    if !@stack[imem.getarg_a(rg.assoc('cop')[1])] then
#	      @pc = @pc + getarg_sbx(cop)
#	      pc = pc + lpl.getarg_sbx(cop) - 1
#	      pc = pc + imem.getarg_sbx(cop) - 1
#	      rg.assoc('pc')[1] += imem.getarg_sbx(rg.assoc('cop')[1]) - 1
	      rg.assoc('pc')[-1] = rg.assoc('pc')[1] + imem.getarg_sbx(rg.assoc('cop')[1]) - 1
#	      next
	    end

	    # メソッドの先頭で引数のセットアップする命令。面倒なので詳細は省略
	  when :ENTER
#	    rg.assoc('pc')[-1] = rg.assoc('pc')[1]

	    # SEND Ra, mid, anumでRaをレシーバにしてシンボルmidの名前のメソッドを
	    # 呼び出す。ただし、引数はanum個あり、R(a+1), R(a+2)... R(a+anum)が引数
	  when :SEND
#	    a = getarg_a(cop)
#	    a = lpl.getarg_a(cop)
	    a = imem.getarg_a(rg.assoc('cop')[1])
#	    mid = @irep.syms[getarg_b(cop)]
#	    mid = irep.syms[lpl.getarg_b(cop)]
	    mid = irep.syms[imem.getarg_b(rg.assoc('cop')[1])]
#	    n = getarg_c(cop)
#	    n = lpl.getarg_c(cop)
	    n = imem.getarg_c(rg.assoc('cop')[1])
#	    newirep = Irep::get_irep(@stack[@sp + a], mid)
	    newirep = Irep::get_irep(@stack[a], mid)
	    if newirep then
#	      @callinfo[@cp] = @sp
#	      @callinfo[@cp] = sp
	      @callinfo[@cp] = rg.assoc('sp')[1] # + 0
	      @cp += 1
#	      @callinfo[@cp] = @pc
#	      @callinfo[@cp] = pc
	      @callinfo[@cp] = rg.assoc('pc')[1]
	      @cp += 1
#	      @callinfo[@cp] = @irep
	      @callinfo[@cp] = irep
	      @cp += 1
#	      @sp += a
#	      sp += a
	      rg.assoc('sp')[1] += a
#	      @pc = 0
#	      pc = -1
#	      rg.assoc('pc')[1] = -1
	      rg.assoc('pc')[-1] = -1
#	      @irep = newirep
	      irep = newirep
#	      @irepid = @irep.id
	      @irepid = irep.id

#	      next
	    else
	      args = []
	      n.times do |i|
#		args.push @stack[@sp + a + i + 1]
		args.push @stack[a + i + 1]
	      end

#	      @stack[@sp + a] = @stack[@sp + a].send(mid, *args)
	      @stack[a] = @stack[a].send(mid, *args)
	    end

	    # RETURN Raで呼び出し元のメソッドに戻る。Raが戻り値になる
	  when :RETURN
	    if @cp == 0 then
#	      return @stack[@sp + getarg_a(cop)]
#	      return @stack[sp + lpl.getarg_a(cop)]
	      return @stack[imem.getarg_a(rg.assoc('cop')[1])]
	    else
#	      @stack[@sp] = @stack[@sp + getarg_a(cop)]
#	      @stack[sp] = @stack[sp + lpl.getarg_a(cop)]
	      @stack[0] = @stack[imem.getarg_a(rg.assoc('cop')[1])]
	      @cp -= 1
#	      @irep = @callinfo[@cp]
	      irep = @callinfo[@cp]
#	      @irepid = @irep.id
	      @irepid = irep.id
	      @cp -= 1
#	      @pc = @callinfo[@cp]
#	      pc = @callinfo[@cp]
#	      rg.assoc('pc')[1] = @callinfo[@cp]
	      rg.assoc('pc')[-1] = @callinfo[@cp]
	      @cp -= 1
#	      @sp = @callinfo[@cp]
#	      sp = @callinfo[@cp]
	      rg.assoc('sp')[1] = @callinfo[@cp] # + 0
	    end
#	  else
#	    printf("Unkown code %s \n", OPTABLE_SYM[get_opcode(cop)])
#	    printf("Unkown code %s \n", OPTABLE_SYM[imem.get_opcode(cop)])
	  end
	end

	if 0 == thi
#	  @flag[0] >>= 1
	  @flag[0] >>= (1 - (thi <=> 0))

#	  @pc = pc + 1
#	  @pc = rg.assoc('pc')[1] + 1
	  rg.assoc('pc').delete_at(1)
	  rg.assoc('pc')[-1] += 1
	  @pc = rg.assoc('pc')[1] # + 0
	  rg.assoc('ctr')[1] *= -1	# kakezan

#	  @sp = sp
	  @sp = rg.assoc('sp')[1]
#	  @irep[0] = irep
	  @irep = irep
	end
	Slp.new.slp 0
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
