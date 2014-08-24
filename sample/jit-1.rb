# -*- coding: iso-2022-jp -*-

class Object
  def to_i_from(k, i = 0)	# unwork ( thread ) mruby 70410200 # mrblib/
    self.kind_of?(k) ? i + self.to_i : self
  end
end

class Numeric
  def to_xeh	# unwork mruby 60410200 # mrblib/
    self.to_i.to_s(0x10).reverse
  end

# def pid_g
#    pid = $$
#    pid = 0 if nil == pid
#    pid
#
#   $$ || self
# end
end

class ENVary < Array
  include RiteOpcodeUtil

  @@slp = 0.001

  @@fl = '~~ritepl'
  @@idb = @@fl
  @@fl += '.loc'
#  @@idb = 0.pid_g.to_xeh + @@idb	# +
#    (rand 0xff).to_xeh +
#    (Time.now.to_f - 0x3fffffff.to_f << 0x10).to_s.split('.')[0][-8..-1].to_xeh
#  @@dlm = '\n'
#  @@dlm = '__--__'
#   @@idx = Hash.new


  def initialize(*a)
#    @m = Mutex.new
#    @@idx = []

    n = a.shift
#   @sz = a.size
    if 1 > n
#      @n = 0 - n
#      return self[@n]
      return
    end
#   @ary = Array.new(n)
    (0..n).each{ |i|
#      @ary = a
      self[i] = *a
    }
  end


#  @@ploc = Fiber.new { |a|
#  @@ploc = Proc.new { |*a|
  def ploc(*a)
#    @m.lock
    begin
      f = File.open(@@fl, 'w')
      f.flock(File::LOCK_EX)
    rescue
      redo
    end
    r = true
    a[0] = a[0].to_xeh
    if 2 > a.size
      r = JSON::parse(ENV[@@idb + a[0]])
#     r = MessagePack.unpack(ENV[@@idb + a[0]])
    else
      ENV[@@idb + a[0]] = JSON::generate(a[1])
#      ENV[@@idb + a[0]] = a[1].to_msgpack
    end
    f.close
#    @m.unlock
    r
#    a = yield(r)
  end
#  }


  def []=(n, v)
#    ENV[@@idb + n.to_s] = v.to_msgpack
#    ENV[@@idb + n.to_s] = MsgPack.dump(v)
    ENV[@@idb + n.to_s] = JSON::generate(v)
#     ploc(n, v)
#     @@ploc.call(n, v)
#     $ploc.resume([n, v])
#    super
  end
  def [](n)
#    p n
#    MessagePack.unpack(ENV[@@idb + n.to_s])
#    MsgPack.load(ENV[@@idb + n.to_s])
     JSON::parse(ENV[@@idb + n.to_s])
#     ploc(n)
#     @@ploc.call(n)
#     $ploc.resume([n])
#    super
  end
##  def [](n = true)
#    MessagePack.unpack(ENV[@@idb + n.to_s])
#    if n
#      ary = []
#      (0 .. @sz).each { |i|
#        ary[i] = JSON::parse(ENV[@@idb] + n)
#      }
#      ary
#    else
#      JSON::parse(ENV[@@idb + n])
#      @@ploc.call(n)
##      self.ploc(n)
#    end
##  end

  def idx(k = '')	# higokan mruby 10410200 ( irep.rb )
#    self[0].index(k)
    self[0][0].index(k)
#    @@idx[k]
  end

#  def idx_s
#    pl = self[0]
#    iiddxx = Hash.new
#    for n in (0 ... pl.size)
#      key = pl[n]
#      iiddxx[key] = n
#    end
#    @@idx = iiddxx
#  end

  def ctr_g
#     self[0][1][self.idx('ctr')].to_i
    pl = self[0][1]
    ctr = pl[self.idx('ctr')].to_i
    cto = pl[self.idx('cto')].to_i
    [ctr, cto]
  end

  def ctr_s(cto)
    pl = self[0]
    pl[1][self.idx('cto')] = cto
    self[0] = pl
  end

#@@pr = Proc.new{
##  ctr = self[1][i_ctr].to_i
#  self[1][i_ctr].to_i
#}

# def lf_i
#   self[1][self.idx('lf')] += 1
#   self[1][@@idx['lf']] += 1
# end

# def lf_d
#   self[1][self.idx('lf')] -= 1
# end

  def slp(t = @@slp)
    sleep t
#    (0 .. self.size << 4).each {
#      (true == true).kind_of?(Object)
#    }
  end

  def ckth(th, tp)
#    self[pc][idx('th')].kind_of?(Array)	# higokan mruby 10410200 ( irep.rb )
#    self[pc][self[0].index('th')].kind_of?(Array)
#    ! th.kind_of?(Array)
    if 'ar' == tp
#      re = ! th.kind_of?(Array)
      ! th.kind_of?(Array)
#   elsif tp.kind_of?(Numeric)
    else
#     re = th[0][tp]
      false != th[tp]	# nil : true
    end
#    re
  end

# @@st_id = Proc.new { |a|
  def st_id(a, pc)
#    for n in (0 ... a.size)
#      v = a[n]
#      if v.kind_of?(Array)
#        v = __send__(v)
#      end
#    end
    a = a.map { |v|
      v = v.kind_of?(Array) ? __send__(v, pc) : v
    }
    return a[0].to_i_from(Numeric) if 2 > a.size

#    opc = a.shift
#    op = a.shift.to_i
    opc = a.first
    op = a.last.to_i
    GC.start
p "#{pc.to_xeh} #{opc} #{op.to_xeh}"
    case opc
    when 'getarg_a'
      a = (op >> 23) & 0x1ff
    when 'getarg_b'
      a = (op >> 14) & 0x1ff
    when 'getarg_c'
      a = (op >> 7) & 0x7f
    when 'getarg_bx'
      a = (op >> 7) & 0xffff
    when 'getarg_sbx'
      a = ((op >> 7) & 0xffff) - (0xffff >> 1)
    when '_sm_'
      a = opc
    when '_im_'
      a = op
    else
      a = 0
    end
    a.to_i_from(Numeric)
  end
#  }

  def pl(pc = 1)
    i_th = self.idx('th')	# higokan mruby 10410200 ( irep.rb )
#    i_th = @@idx['th']
#    i_lf = self[0].index('lf')

#    pc11 = (pc + 1) << 1
    pc1 = pc + 1

#    pl2 = pl2g(pc11)
    pl = plg(pc1, 0)
#    for indx in (0 .. 1)
    for indx in (0 ... pl[i_th].size)

#p    "#{pc.to_xeh} #{pl2[0][0]} #{pl2[0][1].to_xeh}"

#     a = @@st_id.call(a)
#     a = st_id(a)
#      a = st_id(pl2[i_th][indx], pc)
      a = st_id(pl[i_th][indx], pc)
#      pl2[i_th] = a
#      pl2[i_th][indx] = a
      pl[i_th][indx] = a

##     self[pc] = pl2
#      self[pc11 + indx] = pl2
##     self.lf_d
    end

#    for indx in (0 .. 1)
#      self[pc11 + indx] = pl2
#      self[pc11] = pl2
      self[pc1] = pl
#    end
#   GC.start
  end

  def plw(pc = 1)
#    cto = 0
    loop do
#      pc = self.ctr_g
      pc, cto = self.ctr_g
      if pc != cto
#        cto += 1
#       an[cto] = Thread.new(envid) { |envid|

#       self.pl(cto + 2)
#        self.pl(cto)
        self.pl(pc - 1)
	self.ctr_s(cto = pc)
      end
      self.slp
#     sleep 0.002
#     sleep 0.00001
#     sleep 0
####  GC.start
    end
  end

#  private

#  def plg(pc)
  def plg(pc, md = 1)
#  def plg(pc2)
#    pc2 = pc << 1
    i_th = self.idx('th')
    tp = [md, 'ar'][md]
#    br = false
#    while 0 != pc do
#    while (pl = self[pc]).kind_of?(Object) && 0 != pc do
    while pl = self[pc] and 0 != pc do
#      pl = self[pc]
      for indx in (0 .. md)
#      th = pl[self.idx('th')]
	th = pl[i_th][indx]
#      break if ckth(th, 'ar')
#	next if ! ckth(th, 'ar')
	break if ! ckth(th, tp)
	self[pc] = pl
#	br = true if 1 == indx
	br ||= md == indx
      end
      break if br
      self.slp
#     sleep 0.00001
#     sleep 0
    end
    pl
  end

#  def rslt(pc)
  def rslt(pl)
#  def rslt(pc2)
#    pc2 = pc << 1
    i_th = self.idx('th')
#    i_th = @@idx['th']
    i__sp = self.idx('_sp')
#    i__sp = @@idx['_sp']
    i_sym = self.idx('sym')
#    i_sym = @@idx['sym']

#    pl = plg(pc)

    r = pl[i_th]
#    for indx in (0 .. 1)
    for indx in (0 ... pl[i_th].size)
      r[indx] = r[indx].to_i_from(Numeric, pl[i__sp][indx])
    end

    [pl[i_sym], r]
  end

#  def rslts(pc2)
  def rslts(pc)
#    pc2 = pc << 1
#    sym = [-1, -1]
#    r = [-1, -1]
    if 0 != pc
#      for idx in (0 .. 1)
#       sym[idx], r[idx] = self.rslt(plg(pc2 + idx))
#        sym[idx], r[idx] = self.rslt(pc2 , idx)
#	sym, r = self.rslt(pc2)
	sym, r = self.rslt(plg(pc))
#      end
#      r[idx] = r[0] if '_sm_' == r[idx]
      r[1] = r[0] if '_sm_' == r[1]
    end
    [sym, r]
  end

##  def pl2g(pc)
#  def pl2g(pc, md = 1)
##    i_th = self[0].index('th')
#    i_th = self.idx('th')
#    0 == md ? tp = md : tp = 'ar'
#    br = false
##    loop do
#    while 0 != pc do
#      pl2 = self[pc]
#      for indx in (0 .. md)
##	th = pl2[i_th][0]
#	th = pl2[i_th][indx]
##      return(pl2) if false != th[0][0]
##      return(pl2) if ckth(th, 0)
#	next if ! ckth(th, tp)
#	br = true
#      end
#      break if br
#      self.slp
##      sleep 0
#    end
#    pl2
#  end
end

class FibVM
# include RiteOpcodeUtil
  OPTABLE_CODE = Irep::OPTABLE_CODE
  OPTABLE_SYM = Irep::OPTABLE_SYM

  def initialize
    # For Interpriter
    @stack = []                 # スタック(@spより上位をレジスタとして扱う)
    @callinfo = []              # メソッド呼び出しで呼び出し元の情報を格納
    @pc = 0                     # 実行する命令の位置
    @sp = 0                     # スタックポインタ
    @cp = 0                     # callinfoのポインタ
    @irep = [nil]               # 現在実行中の命令列オブジェクト
    @irepid =nil                # 命令列オブジェクトのid(JIT用)


#    rmth = 63
#    rmth = 47
    rmth = 39
#    @pla = Array.new($pcmax)
#   $pltini.call()
#    @pl = ENVary.new((rmth + 1) << 1, [['~~', 0]])
#    @pl = ENVary.new((rmth + 1) << 1, [[[], 0]])
    thini = [false, 0]
#    @pl = ENVary.new((rmth + 1) << 1, thini, [thini, thini])
    @pl = ENVary.new(rmth + 1, [thini, thini], [], [])

    plini
#    @pl.idx_s

#    @idx = Hash.new
#    pl0 = @pl0
#    for n in (0 ... pl0.size)
#      k = pl0[n]
#      @idx[k] = n
#    end

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
    @pl[0] = [['th',         'sym', '_sp', 'ctr', 'cto'],	# mruby 20410200 : higokan ? : ary_many
	      [[thini,thini],   0, [0, 0],    0,     0]]	# mruby 70410200 : 4x2 ok , 5x2 ng

    @pl0 = @pl[0][0]
    @pl1 = @pl[0][1]

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

#  def fls(pc2, *sym)
#  def fls(pc, *sym)
  def fls(pc)
    return if 0 != @flg.size	# || 0 == pc2

#    sym, r = @pl.rslts(pc2)
    sym, r = @pl.rslts(pc)

#p "#{(pc - 1).to_xeh} #{sym[0]} #{r[0].to_xeh}"
p "#{(pc - 1).to_xeh} #{sym} #{r[0].to_xeh}"
#    case sym[0]
    case sym.to_sym
    when :MOVE
#        @stack[@sp + getarg_a(cop)] = @stack[@sp + getarg_b(cop)]
      @stack[r[1]] = @stack[r[0]]
    when :LOADL
#	@stack[@sp + getarg_a(cop)] = @irep.pool[getarg_bx(cop)]
      @stack[r[1]] = @irep[0].pool[r[0]]
    when :LOADI
#        @stack[@sp + getarg_a(cop)] = getarg_sbx(cop)
      @stack[r[1]] = r[0]
    when :LOADSYM
#	@stack[@sp + getarg_a(cop)] = @irep.syms[getarg_bx(cop)]
      @stack[r[1]] = @irep[0].syms[r[0]]
    when :LOADSELF
#        @stack[@sp + getarg_a(cop)] = @stack[@sp]
      @stack[r[1]] = @stack[r[0]]
    when :LOADT
#        @stack[@sp + getarg_a(cop)] = true
      @stack[r[1]] = r[0]
    when :ADD
#        @stack[@sp + getarg_a(cop)] += @stack[@sp + getarg_a(cop) + 1]
      @stack[r[1]] += @stack[r[0] + 1]
    when :ADDI
#        @stack[@sp + getarg_a(cop)] += getarg_c(cop)
      @stack[r[1]] += r[0]
    when :SUB
#        @stack[@sp + getarg_a(cop)] -= @stack[@sp + getarg_a(cop) + 1]
      @stack[r[1]] -= @stack[r[0] + 1]
    when :SUBI
#        @stack[@sp + getarg_a(cop)] -= getarg_c(cop)
      @stack[r[1]] -= r[0]
    when :MUL
#        @stack[@sp + getarg_a(cop)] *= @stack[@sp + getarg_a(cop) + 1]
      @stack[r[1]] *= @stack[r[0] + 1]
    when :DIV
#        @stack[@sp + getarg_a(cop)] /= @stack[@sp + getarg_a(cop) + 1]
      @stack[r[1]] /= @stack[r[0] + 1]
    when :EQ
#        val = (@stack[@sp + getarg_a(cop)] == @stack[@sp + getarg_a(cop) + 1])
#        @stack[@sp + getarg_a(cop)] = val
      val = @stack[r[1]] == @stack[r[0] + 1]
#      @stack[@sp + getarg_a(cop)] = val
      @stack[r[1]] = val
     end
  end

#  def iset(sp, arg, pc, *sym)
  def iset(sym, pc, ary)
    pc1 = pc + 1

    fls(pc)

    pl = @pl[0]
#    pl0 = @pl0
#    pl1 = @pl1
#    pl0 = pl[0]
    pl1 = pl[1]

    i_th = @pl.idx('th')	# higokan mruby 10410200 ( irep.rb )
#    i_th = @idx['th']
    i_sym = @pl.idx('sym')
#    i_sym = @idx['sym']
    i__sp = @pl.idx('_sp')
#    i__sp = @idx['_sp']
    i_ctr = @pl.idx('ctr')
#    i_ctr = @idx['ctr']
#    i_lf = @idx['lf']

#    pc2 = pc << 1
#    fls(pc, sym) # if 0 != ab

#   pl2 = @pl[pc2ab + 2]
    pl2 = @pl[pc1]
    pl2[i_sym] = sym
#    for ab in (0 .. 1)
    for indx in (0 ... ary.size)
#     pc2ab = pc2 + ab
#      sp, arg = ary[ab]
      sp, arg = ary[indx]

#      pl2[i__sp][ab] = sp
      pl2[i__sp][indx] = sp
#      pl2[i_th][ab] = arg
      pl2[i_th][indx] = arg
    end
#   @pl[pc2ab + 2] = pl2
    @pl[pc1] = pl2

#    pl1[i_ctr] += 1
#   pl1[i_ctr] = pc2ab
    pl1[i_ctr] = pc1
#   pl1[i_lf] += 1
#   @pl[1] = pl1
    pl[1] = pl1
    @pl[0] = pl

#    pl2 = @pl[pc2 + 2]
#    pl2[i_th][ab] = arg
#    @pl[pc2 + 2] = pl2
  end

  def eval(irep)
    @irep[0] = irep
#   @irepid = @irep.id
    @irepid = irep.id

    @flg = [true]

    while true
      pc = @pc

      #　命令コードの取り出し
#     cop = @irep.iseq[@pc]
      cop = irep.iseq[@pc]
      sp = @sp ##

#     case OPTABLE_SYM[get_opcode(cop)]
#     sym = OPTABLE_SYM[get_opcode(cop)]
      sym = OPTABLE_SYM[@pl.get_opcode(cop)]
p "#{pc.to_xeh} #{sym}"

      case sym
        # 何もしない
      when :NOP

        # MOVE Ra, RbでレジスタRaにレジスタRbの内容をセットする
      when :MOVE
#       @stack[@sp + getarg_a(cop)] = @stack[@sp + getarg_b(cop)]
#	iset(sp, ['getarg_b', cop], pc, sym)
#	iset(sp, ['getarg_a', cop], pc)
	iset(sym, pc, [[sp, ['getarg_b', cop]], [sp, ['getarg_a', cop]]])

        # LOADL Ra, pb でレジスタRaに定数テーブル(pool)のpb番目の値をセットする
      when :LOADL
#	@stack[@sp + getarg_a(cop)] = @irep.pool[getarg_bx(cop)]
#	iset(0 , ['getarg_bx', cop], pc, sym)
#	iset(sp, ['getarg_a',  cop], pc)
	iset(sym, pc, [[0, ['getarg_bx', cop]], [sp, ['getarg_a', cop]]])

        # LOADI Ra, n でレジスタRaにFixnumの値 nをセットする
      when :LOADI
#       @stack[@sp + getarg_a(cop)] = getarg_sbx(cop)
#	iset(0 , ['getarg_sbx', cop], pc, sym)
#	iset(sp, ['getarg_a',   cop], pc)
	iset(sym, pc, [[0, ['getarg_sbx', cop]], [sp, ['getarg_a', cop]]])

        # LOADSELF Ra でレジスタRaに現在のselfをセットする
      when :LOADSELF
#	@stack[@sp + getarg_a(cop)] = @stack[@sp]
#	iset(sp , ['_im_',      0], pc, sym)
#	iset(sp, ['getarg_a', cop], pc)
	iset(sym, pc, [[sp, ['_im_', 0]], [sp, ['getarg_a', cop]]])

        # ADD Ra, Rb でレジスタRaにRa+Rbをセットする
      when :ADD
#	@stack[@sp + getarg_a(cop)] += @stack[@sp + getarg_a(cop) + 1]
#	iset(sym, pc, [[sp, ['getarg_a', cop]], [sp, ['getarg_a', cop]]])
	iset(sym, pc, [[sp, ['getarg_a', cop]], [0, ['_sm_', 0]]])

        # SUB Ra, n でレジスタRaにRa-nをセットする
      when :SUBI
#	@stack[@sp + getarg_a(cop)] -= getarg_c(cop)
#	iset(0,  ['getarg_c', cop], pc, sym)
#	iset(sp, ['getarg_a', cop], pc)
	iset(sym, pc, [[0, ['getarg_c', cop]], [sp, ['getarg_a', cop]]])

        # EQ Ra でRaとR(a+1)を比べて同じならtrue, 違うならfalseをRaにセットする
      when :EQ
#	val = (@stack[@sp + getarg_a(cop)] == @stack[@sp + getarg_a(cop) + 1])
#	@stack[@sp + getarg_a(cop)] = val
#	iset(sym, pc, [[sp, ['getarg_a', cop]], [sp, ['getarg_a', cop]]])
	iset(sym, pc, [[sp, ['getarg_a', cop]], [0, ['_sm_', 0]]])

      else
	iset(sym, pc, [[0, ['~~', 0]],[0, ['~~', 0]]])
#	pc2 = @pc << 1
#	fls(pc2, sym)

#	while (ctr, cto = @pl.ctr_g) and 0 != ctr - cto # pc - cto
#	  @pl.slp
#	end

	plini
	@flg.pop
#	@flg.push(true)
#	@flg.push(true)
	@flg.push(true, true)

	case sym

	  # JMP nでpcをnだけ増やす。ただし、nは符号付き
	when :JMP
##	  @pc = @pc + getarg_sbx(cop)
#	  pc = pc + getarg_sbx(cop) - 1
	  pc = pc + @pl.getarg_sbx(cop) - 1
##	  next

	  # JMPNOT Ra, nでもしRaがnilかfalseならpcをnだけ増やす。ただし、nは符号付き
	when :JMPNOT
###	  if !@stack[@sp + getarg_a(cop)] then
	  if !@stack[sp + @pl.getarg_a(cop)] then
##	    @pc = @pc + getarg_sbx(cop)
#	    pc = pc + getarg_sbx(cop) - 1
	    pc = pc + @pl.getarg_sbx(cop) - 1
##	    next
	  end

	  # メソッドの先頭で引数のセットアップする命令。面倒なので詳細は省略
	when :ENTER

	  # SEND Ra, mid, anumでRaをレシーバにしてシンボルmidの名前のメソッドを
	  # 呼び出す。ただし、引数はanum個あり、R(a+1), R(a+2)... R(a+anum)が引数
	when :SEND
#	  a = getarg_a(cop)
	  a = @pl.getarg_a(cop)
#	  mid = @irep.syms[getarg_b(cop)]
	  mid = irep.syms[@pl.getarg_b(cop)]
#	  n = getarg_c(cop)
	  n = @pl.getarg_c(cop)
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
#	    return @stack[sp + getarg_a(cop)]
	    return @stack[sp + @pl.getarg_a(cop)]
	  else
###	    @stack[@sp] = @stack[@sp + getarg_a(cop)]
#	    @stack[sp] = @stack[sp + getarg_a(cop)]
	    @stack[sp] = @stack[sp + @pl.getarg_a(cop)]
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
#	  printf("Unkown code %s \n", OPTABLE_SYM[get_opcode(cop)])
	  printf("Unkown code %s \n", OPTABLE_SYM[@pl.get_opcode(cop)])
	end
      end

      @flg.pop
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
