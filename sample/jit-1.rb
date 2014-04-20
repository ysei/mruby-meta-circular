# -*- coding: iso-2022-jp -*-

class Numeric
  def to_xeh
    self.to_i.to_s(0x10).reverse
  end

#  def pid_g
#    pid = $$
#    pid = 0 if nil == pid
#    pid
#  end
end

class ENVary < Array
  @@slp = 0.001

  @@fl = '~~ritepl'
  @@idb = @@fl
  @@fl += '.loc'
#  @@idb = 0.pid_g.to_xeh + @@idb       # +
#    (rand 0xff).to_xeh +
#    (Time.now.to_f - 0x3fffffff.to_f << 0x10).to_s.split('.')[0][-8..-1].to_xeh
#  @@dlm = '\n'
#  @@dlm = '__--__'
   @@idx = Hash.new


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

  def ctr_g
    self[1][self[0].index('ctr')].to_i
#    ctr = self[1][self[0].index('ctr')]
#    ctr.to_i
  end

#@@pr = Proc.new{
#  ctr = self[1][i_ctr].to_i
#  ctr
#}

#  def lf_i
#    self[1][self[0].index('lf')] += 1
##    self[1][self.idx('lf')] += 1
##    self[1][@@idx['lf']] += 1
#  end

#  def lf_d
#    self[1][self[0].index('lf')] -= 1
##    self[1][self.idx('lf')] -= 1
##    self[1][@@idx['lf']] -= 1
#  end

  def slp(t = @@slp)
    sleep t
#    (0 .. self.size << 4).each {
#      (true == true).kind_of?(Object)
#    }
  end

  def idx(k = '')
    self[0].index(k)
#    @@idx[k]
  end

  def idx_s
    pl = self[0]
    iiddxx = Hash.new
    for n in (0 ... pl.size)
      key = pl[n]
      iiddxx[key] = n
    end
    @@idx = iiddxx
  end

  def ckth(th)
#    self[pc][idx('th')].kind_of?(Array)
#    self[pc][self[0].index('th')].kind_of?(Array)
    ! th.kind_of?(Array)
  end

#  @@st_id = Proc.new { |a|
  def st_id(a, pc)
    for n in (0 ... a.size)
      v = a[n]
      if v.kind_of?(Array)
        v = __send__(v)
      end
    end
    opc = a.shift
    op = a.shift.to_i
#    GC.start
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
    a.to_i if a.kind_of?(Numeric)
    a
  end
#  }

  def pl(pc = 1)
    i_th = self[0].index('th')
#    i_th = self.idx('th')
#    i_th = @@idx['th']
#    i_lf = self[0].index('lf')

    pl2 = pl2g(pc)
#p "#{((pc >> 1) - 1).to_xeh} #{pl2[0][0]} #{pl2[0][1].to_xeh}"

#    a = @@st_id.call(a)
#    a = st_id(a)
    a = st_id(pl2[i_th], (pc >> 1) - 1)

    pl2[i_th] = a
    self[pc] = pl2
#    self.lf_d
#    GC.start
  end

  def plw(pc = 1)
    cto = 0
    loop do
      pc2 = self.ctr_g << 1
      if pc2 != cto
        cto += 1
#        an[cto] = Thread.new(envid) { |envid|

        self.pl(cto + 2)

      end
      self.slp
#      sleep @@slp
#      sleep 0.002
#     sleep 0.00001
#      sleep 0
####  GC.start
    end
  end

#  private

  def rslt(pc)
    i_th = self[0].index('th')
#    i_th = self.idx('th')
#    i_th = @@idx['th']
    i__sp = self[0].index('_sp')
#    i__sp = self.idx('_sp')
#    i__sp = @@idx['_sp']
    i_sym = self[0].index('sym')
#    i_sym = self.idx('sym')
#    i_sym = @@idx['sym']


    while 0 != pc do
      pl = self[pc]
      th = pl[i_th]
      break if ckth(th)
      self.slp
#      sleep @@slp
#      sleep 0.001
#      sleep 0.00001
#      sleep 0
    end

    sp = pl[i__sp].to_i
    r = pl[i_th]
    r = sp + r.to_i if r.kind_of?(Numeric)
    [pl[i_sym], r]
#    [pl[i_sym], sp + pl[i_th].to_i]
  end

  def rslts(pc2)
    sym = [-1, -1]
    r = [-1, -1]
    if 0 != pc2
      for idx in (0 .. 1)
        sym[idx], r[idx] = self.rslt(pc2 + idx)
      end
      r[idx] = r[0] if '_sm_' == r[idx]
    end
    [sym, r]
  end

  def pl2g(pc)
    i_th = self[0].index('th')
    loop do
      pl2 = self[pc]
      a = pl2[i_th]
      return(pl2) if false != a[0][0]
      self.slp
#      sleep @@slp
#      sleep 0.001
#      sleep 0
    end
  end
end

class FibVM
  include RiteOpcodeUtil
  OPTABLE_CODE = Irep::OPTABLE_CODE
  OPTABLE_SYM = Irep::OPTABLE_SYM

  def initialize
    # For Interpriter
    @stack = []                 # スタック(@spより上位をレジスタとして扱う)
    @callinfo = []              # メソッド呼び出しで呼び出し元の情報を格納
    @pc = 0                     # 実行する命令の位置
    @sp = 0                     # スタックポインタ
    @cp = 0                     # callinfoのポインタ
    @irep = nil                 # 現在実行中の命令列オブジェクト
    @irepid =nil                # 命令列オブジェクトのid(JIT用)
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
    @irep = irep
    @irepid = @irep.id

    @flg = [true]

    while true
      #　命令コードの取り出し
      cop = @irep.iseq[@pc]
      sp = @sp  ##

#     case OPTABLE_SYM[get_opcode(cop)]
      sym = OPTABLE_SYM[get_opcode(cop)]

      case sym
        # 何もしない
      when :NOP

        # MOVE Ra, RbでレジスタRaにレジスタRbの内容をセットする
      when :MOVE
        @stack[@sp + getarg_a(cop)] = @stack[@sp + getarg_b(cop)]

        # LOADL Ra, pb でレジスタRaに定数テーブル(pool)のpb番目の値をセットする
      when :LOADL
        @stack[@sp + getarg_a(cop)] = @irep.pool[getarg_bx(cop)]

        # LOADI Ra, n でレジスタRaにFixnumの値 nをセットする
      when :LOADI
        @stack[@sp + getarg_a(cop)] = getarg_sbx(cop)

        # LOADSELF Ra でレジスタRaに現在のselfをセットする
      when :LOADSELF
        @stack[@sp + getarg_a(cop)] = @stack[@sp]

        # ADD Ra, Rb でレジスタRaにRa+Rbをセットする
      when :ADD
        @stack[@sp + getarg_a(cop)] += @stack[@sp + getarg_a(cop) + 1]

        # SUB Ra, n でレジスタRaにRa-nをセットする
      when :SUBI
        @stack[@sp + getarg_a(cop)] -= getarg_c(cop)

        # EQ Ra でRaとR(a+1)を比べて同じならtrue, 違うならfalseをRaにセットする
      when :EQ
        val = (@stack[@sp + getarg_a(cop)] == @stack[@sp + getarg_a(cop) + 1])
        @stack[@sp + getarg_a(cop)] = val

      else

        @flg.pop
        @flg.push(true)
        @flg.push(true)

	case sym

	  # JMP nでpcをnだけ増やす。ただし、nは符号付き
	when :JMP
##	  @pc = @pc + getarg_sbx(cop)
	  @pc = @pc + getarg_sbx(cop) - 1
##	  next

	  # JMPNOT Ra, nでもしRaがnilかfalseならpcをnだけ増やす。ただし、nは符号付き
	when :JMPNOT
	  if !@stack[@sp + getarg_a(cop)] then
##	    @pc = @pc + getarg_sbx(cop)
	    @pc = @pc + getarg_sbx(cop) - 1
##	    next
	  end

	  # メソッドの先頭で引数のセットアップする命令。面倒なので詳細は省略
	when :ENTER

	  # SEND Ra, mid, anumでRaをレシーバにしてシンボルmidの名前のメソッドを
	  # 呼び出す。ただし、引数はanum個あり、R(a+1), R(a+2)... R(a+anum)が引数
	when :SEND
	  a = getarg_a(cop)
	  mid = @irep.syms[getarg_b(cop)]
	  n = getarg_c(cop)
	  newirep = Irep::get_irep(@stack[@sp + a], mid)
	  if newirep then
	    @callinfo[@cp] = @sp
	    @cp += 1
	    @callinfo[@cp] = @pc
	    @cp += 1
	    @callinfo[@cp] = @irep
	    @cp += 1
	    @sp += a
##	    @pc = 0
	    @pc = -1
	    @irep = newirep
	    @irepid = @irep.id

##	    next
	  else
	    args = []
	    n.times do |i|
	      args.push @stack[@sp + a + i + 1]
	    end

	    @stack[@sp + a] = @stack[@sp + a].send(mid, *args)
	  end

	  # RETURN Raで呼び出し元のメソッドに戻る。Raが戻り値になる
	when :RETURN
	  if @cp == 0 then
	    return @stack[@sp + getarg_a(cop)]
	  else
	    @stack[@sp] = @stack[@sp + getarg_a(cop)]
	    @cp -= 1
	    @irep = @callinfo[@cp]
	    @irepid = @irep.id
	    @cp -= 1
	    @pc = @callinfo[@cp]
	    @cp -= 1
	    @sp = @callinfo[@cp]
	  end
	else
	  printf("Unkown code %s \n", OPTABLE_SYM[get_opcode(cop)])
	end
      end

      @flg.pop
      @pc = @pc + 1
      @sp = sp  ##
    end
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
