defmodule Minesweeper do

  # Extra helpers
  def get_mines_example(), do: [
    [false, false, true, false, false],
    [false, true, false, true, false],
    [false, false, false, false, false],
    [false, false, false, false, false],
    [false, false, false, false, false]
   ]

  def get_tab_example(), do: [
    ["-", "-", "-", "-", "-"],
    ["-", "-", "-", "-", "-"],
    ["-", "-", "-", "-", "-"],
    ["-", "-", "-", "-", "-"],
    ["-", "-", "-", "-", "-"]
  ]

  def get_tam([]), do: 0
  def get_tam([_h|t]), do: get_tam(t) + 1
  # PRIMEIRA PARTE - FUNÇÕES PARA MANIPULAR OS TABULEIROS DO JOGO (MATRIZES)

  # A ideia das próximas funções é permitir que a gente acesse uma lista usando um indice,
  # como se fosse um vetor

  # get_arr/2 (get array):  recebe uma lista (vetor) e uma posicao (p) e devolve o elemento
  # na posição p do vetor. O vetor começa na posição 0 (zero). Não é necessário tratar erros.


  def get_arr(_, n) when n<0, do: raise "posicao invalida"
  def get_arr([h|_t], 0), do: h
  def get_arr([_h|t], n), do: get_arr(t, n-1)

  # update_arr/3 (update array): recebe uma lista(vetor), uma posição (p) e um novo valor (v)e devolve um
  # novo vetor com o valor v na posição p. O vetor começa na posição 0 (zero)

  def update_arr(_,n,_) when n<0, do: raise "posicao invalida"
  def update_arr([_h|t],0,v), do: [v|t]
  def update_arr([h|t],n,v), do: [h|update_arr(t,n-1,v)]

  # O tabuleiro do jogo é representado como uma matriz. Uma matriz, nada mais é do que um vetor de vetores.
  # Dessa forma, usando as operações anteriores, podemos criar funções para acessar os tabuleiros, como
  # se  fossem matrizes:

  # get_pos/3 (get position): recebe um tabuleiro (matriz), uma linha (l) e uma coluna (c) (não precisa validar).
  # Devolve o elemento na posicao tabuleiro[l,c]. Usar get_arr/2 na implementação

  def get_pos(tab,l,c) do
    tab
    |> get_arr(l)
    |> get_arr(c)
  end

  # update_pos/4 (update position): recebe um tabuleiro, uma linha, uma coluna e um novo valor. Devolve
  # o tabuleiro modificado com o novo valor na posiçao linha x coluna. Usar update_arr/3 e get_arr/2 na implementação

  def update_pos(tab,l,c,v), do: update_arr(tab,l, update_arr(get_arr(tab, l), c, v))

  # SEGUNDA PARTE: LÓGICA DO JOGO

  #-- is_mine/3: recebe um tabuleiro com o mapeamento das minas, uma linha, uma coluna. Devolve true caso a posição contenha
  # uma mina e false caso contrário. Usar get_pos/3 na implementação
  #
  # Exemplo de tabuleiro de minas:

  # _mines_board = [[false, false, false, false, false, false, false, false, false],
  #                 [false, false, false, false, false, false, false, false, false],
  #                 [false, false, false, false, false, false, false, false, false],
  #                 [false, false, false, false, false, false, false, false, false],
  #                 [false, false, false, false, true , false, false, false, false],
  #                 [false, false, false, false, false, true, false, false, false],
  #                 [false, false, false, false, false, false, false, false, false],
  #                 [false, false, false, false, false, false, false, false, false],
  #                 [false, false, false, false, false, false, false, false, false]]

  # esse tabuleiro possuí minas nas posições 4x4 e 5x5

  def is_mine(tab,l,c), do: is_valid_pos(get_tam(tab),l,c) && get_pos(tab,l,c) == true

  # is_valid_pos/3 recebe o tamanho do tabuleiro (ex, em um tabuleiro 9x9, o tamanho é 9),
  # uma linha e uma coluna, e diz se essa posição é válida no tabuleiro. Por exemplo, em um tabuleiro
  # de tamanho 9, as posições 1x3,0x8 e 8x8 são exemplos de posições válidas. Exemplos de posições
  # inválidas seriam 9x0, 10x10 e -1x8

  def is_valid_pos(tamanho,l,c), do: l >= 0 && c >= 0 && l < tamanho && c < tamanho

  # valid_moves/3: Dado o tamanho do tabuleiro e uma posição atual (linha e coluna), retorna uma lista
  # com todas as posições adjacentes à posição atual
  # Exemplo: Dada a posição linha 3, coluna 3, as posições adjacentes são: [{2,2},{2,3},{2,4},{3,2},{3,4},{4,2},{4,3},{4,4}]
  #   ...   ...      ...    ...   ...
  #   ...  (2,2)    (2,3)  (2,4)  ...
  #   ...  (3,2)    (3,3)  (3,4)  ...
  #   ...  (4,2)    (4,3)  (4,4)  ...
  #   ...   ...      ...    ...   ...

  #  Dada a posição (0,0) que é um canto, as posições adjacentes são: [(0,1),(1,0),(1,1)]

  #  (0,0)  (0,1) ...
  #  (1,0)  (1,1) ...
  #   ...    ...  ..
  # Uma maneira de resolver seria gerar todas as 8 posições adjacentes e depois filtrar as válidas usando is_valid_pos

  # def valid_moves(tam,l,c), do: Enum.filter(valid_moves(tam, l-1,c-1,l,c), fn {l,c} -> is_valid_pos(tam,l,c) end)
  def valid_moves(tam,l,c), do: valid_moves(tam, l-1,c-1,l,c)
  def valid_moves(tam,l,c,initial_l,initial_c) do
    cond do
      abs(c-initial_c) > 1 -> valid_moves(tam,l+1,initial_c-1,initial_l, initial_c)
      abs(l-initial_l) > 1 -> []
      (l == initial_l && c == initial_c) || !is_valid_pos(tam,l,c) -> valid_moves(tam,l,c+1,initial_l,initial_c)
      true -> [{l,c} | valid_moves(tam,l,c+1,initial_l,initial_c)]
    end
  end


  # conta_minas_adj/3: recebe um tabuleiro com o mapeamento das minas e uma  uma posicao  (linha e coluna), e conta quantas minas
  # existem nas posições adjacentes

  def conta_minas_adj(_mines, []), do: 0
  def conta_minas_adj(mines, [{l,c}|t]) do
    cond do
      is_mine(mines,l,c) -> conta_minas_adj(mines, t) + 1
      true -> conta_minas_adj(mines, t)
    end
  end
  def conta_minas_adj(mines,l,c), do: conta_minas_adj(mines,valid_moves(get_tam(mines),l,c))
  def _test_conta_minas_adj(l,c), do: conta_minas_adj(get_mines_example(),l,c)

  # abre_jogada/4: é a função principal do jogo!!
  # recebe uma posição a ser aberta (linha e coluna), o mapa de minas e o tabuleiro do jogo. Devolve como
  # resposta o tabuleiro do jogo modificado com essa jogada.
  # Essa função é recursiva, pois no caso da entrada ser uma posição sem minas adjacentes, o algoritmo deve
  # seguir abrindo todas as posições adjacentes até que se encontre posições adjacentes à minas.
  # Vamos analisar os casos:
  # - Se a posição a ser aberta é uma mina, o tabuleiro não é modificado e encerra
  # - Se a posição a ser aberta já foi aberta, o tabuleiro não é modificado e encerra
  # - Se a posição a ser aberta é adjacente a uma ou mais minas, devolver o tabuleiro modificado com o número de
  # minas adjacentes na posição aberta
  # - Se a posição a ser aberta não possui minas adjacentes, abrimos ela com zero (0) e recursivamente abrimos
  # as outras posições adjacentes a ela

  def is_opened(tab,l,c), do: is_number(get_pos(tab,l,c))

  def abre_jogada([{l,c}|t],mines,tab), do: abre_jogada(t,mines,abre_jogada(l,c,mines,tab))
  def abre_jogada([],_,tab), do: tab
  def abre_jogada(l,c,mines,tab) do
    cond do
      !is_valid_pos(get_tam(mines),l,c) ->
        IO.puts IO.ANSI.red() <> "Posição Inválida, insira novamente outra posição"
        tab
      is_mine(mines,l,c) -> tab
      is_opened(tab,l,c) -> tab
      conta_minas_adj(mines,l,c) == 0 ->
        get_tam(tab)
          |> valid_moves(l,c)
          |> abre_jogada(mines,update_pos(tab,l,c,0))
      true -> update_pos(tab,l,c,conta_minas_adj(mines,l,c))
    end
  end


# abre_posicao/4, que recebe um tabueiro de jogos, o mapa de minas, uma linha e uma coluna
# Essa função verifica:
# - Se a posição {l,c} já está aberta (contém um número), então essa posição não deve ser modificada
# - Se a posição {l,c} contém uma mina no mapa de minas, então marcar  com "*" no tabuleiro
# - Se a posição {l,c} está fechada (contém "-"), escrever o número de minas adjascentes a esssa posição no tabuleiro (usar conta_minas)


  def abre_posicao(tab,minas,l,c) do
    cond do
      is_mine(minas,l,c) -> update_pos(tab,l,c,"*")
      !is_opened(tab,l,c) -> update_pos(tab,l,c,conta_minas_adj(minas,l,c))
      true -> tab
    end
  end



# abre_tabuleiro/2: recebe o mapa de Minas e o tabuleiro do jogo, e abre todo o tabuleiro do jogo, mostrando
# onde estão as minas e os números nas posições adjecentes às minas.Essa função é usada para mostrar
# todo o tabuleiro no caso de vitória ou derrota. Para implementar esta função, usar a função abre_posicao/4

  def abre_tabuleiro(_minas,tab,l,_c) when l < 0, do: tab
  def abre_tabuleiro(minas,tab,l,c) when c < 0, do: abre_tabuleiro(minas,tab,l-1,get_tam(get_arr(minas,0))-1)
  def abre_tabuleiro(minas,tab,l,c), do: abre_tabuleiro(minas, abre_posicao(tab,minas,l,c),l,c-1)
  def abre_tabuleiro(minas,tab) do
    max_index = get_tam(tab) - 1 # quantidade de linhas (mudar caso queira suportar tabuleiros retangulares)
    abre_tabuleiro(minas,tab,max_index,max_index)
  end

# board_to_string/1: -- Recebe o tabuleiro do jogo e devolve uma string que é a representação visual desse tabuleiro.
# Essa função é aplicada no tabuleiro antes de fazer o print dele na tela. Usar a sua imaginação para fazer um
# tabuleiro legal. Olhar os exemplos no .pdf com a especificação do trabalho. Não esquecer de usar \n para quebra de linhas.
# Você pode quebrar essa função em mais de uma: print_header, print_linhas, etc...

  def get_space_between_cells(), do: "   "
  def get_linecounter_space(), do: "     "

  def get_divider(str,0), do: str
  def get_divider(str,n), do: str <> get_divider(str,n-1)

  def get_columns(c_count) do
    Range.new(0,c_count-1)
    |> Enum.map(fn x -> Integer.to_string(x) end)
    |> Enum.join(get_space_between_cells())
  end

  def print_header(c_count), do: IO.puts IO.ANSI.green() <> get_linecounter_space() <> get_columns(c_count)
  def get_line_cells(line,c_count) do
      Range.new(0,c_count-1)
        |> Enum.map(fn x -> get_arr(line, x) end)
        |> Enum.join(get_space_between_cells())
  end

  def print_line(line_vector,l,c_count) do
    IO.puts IO.ANSI.green() <> Integer.to_string(l) <> "  | " <> IO.ANSI.white() <>  get_line_cells(line_vector,c_count)
  end

  def board_to_string(tab) do
    IO.puts "\n\n\n"
    qt_colunas = tab |> get_arr(0) |> get_tam()
    print_header(qt_colunas)
    IO.puts "   " <> get_divider("_",qt_colunas + (qt_colunas * 3))
    Enum.reduce(tab, 0, fn (line, i) ->
      print_line(line,i,qt_colunas)
      i+1
    end)

    IO.puts IO.ANSI.green() <> "   " <> get_divider("-",qt_colunas + (qt_colunas * 3))
  end

# gera_lista/2: recebe um inteiro n, um valor v, e gera uma lista contendo n vezes o valor v

  def gera_lista(0,_v), do: []
  def gera_lista(n,v), do: [v|gera_lista(n-1,v)]

# -- gera_tabuleiro/1: recebe o tamanho do tabuleiro de jogo e gera um tabuleiro  novo, todo fechado (todas as posições
# contém "-"). Usar gera_lista

  def gera_tabuleiro(n), do: gera_lista(n,gera_lista(n,"-"))

# -- gera_mapa_de_minas/1: recebe o tamanho do tabuleiro e gera um mapa de minas zero, onde todas as posições contém false

  def gera_mapa_de_minas(n), do: gera_lista(n,gera_lista(n,false))


# conta_fechadas/1: recebe um tabueleiro de jogo e conta quantas posições fechadas existem no tabuleiro (posições com "-")

  def conta_fechadas(tab) do
    Enum.reduce(tab, 0, fn (linha,acc1) ->
      acc1 + Enum.reduce(linha, 0, fn (item, acc2) ->
        cond do
          !is_number(item) -> acc2 + 1
          true -> acc2
        end
      end)
    end)
  end

# -- conta_minas/1: Recebe o tabuleiro de Minas (MBoard) e conta quantas minas existem no jogo

  def conta_minas(minas) do
    Enum.reduce(minas, 0, fn (linha,acc1) ->
      acc1 + Enum.reduce(linha, 0, fn (item, acc2) ->
        cond do
          item == true -> acc2 + 1
          true -> acc2
        end
      end)
    end)
  end

# end_game?/2: recebe o tabuleiro de minas, o tauleiro do jogo, e diz se o jogo acabou.
# O jogo acabou quando o número de casas fechadas é igual ao numero de minas
  def end_game(minas,tab), do:  conta_minas(minas) == conta_fechadas(tab)

#### fim do módulo
end

###################################################################
###################################################################

# A seguir está o motor do jogo!
# Somente descomentar essas linhas quando as funções do módulo anterior estiverem
# todas implementadas
defmodule Motor do
 def main() do
  v = IO.gets("Digite o tamanho do tabuleiro: \n")
  {size,_} = Integer.parse(v)
  {_id,_label,m_percent,_color} = menu_difficult()
  minas = gen_mines_board(size,m_percent)
  IO.inspect minas
  tabuleiro = Minesweeper.gera_tabuleiro(size)
  game_loop(minas,tabuleiro)
 end


 def end_game() do
    v = IO.gets("Fim de jogo, deseja iniciar outra partida? s/n")
    if String.trim(v) == "s" do
      Motor.main()
    else
      IO.puts "Até mais!"
    end
 end



 def open_position(minas,tabuleiro) do
  { linha, coluna } = get_user_coords(tabuleiro)

  if (Minesweeper.is_mine(minas,linha,coluna)) do
    IO.puts "VOCÊ PERDEU!!!!!!!!!!!!!!!!"
    IO.puts Minesweeper.board_to_string(Minesweeper.abre_tabuleiro(minas,tabuleiro))
    IO.puts "TENTE NOVAMENTE!!!!!!!!!!!!"
    Motor.end_game()
  else
    novo_tabuleiro = Minesweeper.abre_jogada(linha,coluna,minas,tabuleiro)
    if (Minesweeper.end_game(minas,novo_tabuleiro)) do
        IO.puts "VOCÊ VENCEU!!!!!!!!!!!!!!"
        IO.puts Minesweeper.board_to_string(Minesweeper.abre_tabuleiro(minas,novo_tabuleiro))
        IO.puts "PARABÉNS!!!!!!!!!!!!!!!!!"
        Motor.end_game()
    else
        game_loop(minas,novo_tabuleiro)
    end
  end
 end

 def put_flag(minas,tabuleiro) do
  { linha, coluna } = get_user_coords(tabuleiro)
  novo_tabuleiro = Minesweeper.update_pos(tabuleiro,linha,coluna,"F")
  game_loop(minas,novo_tabuleiro)
 end

 def call_end_game(_,_) do
  Motor.end_game()
 end

 def get_actions() do
   [
    {1, "Abrir posição", &Motor.open_position/2},
    {2, "Colocar bandeira", &Motor.put_flag/2},
    {3, "Sair", &Motor.call_end_game/2}
  ]
 end

 def print_action([]), do: IO.puts ""

 def print_action([{id, action, _}|t]) do
   IO.puts "#{id} - #{action}"
   print_action(t)
 end

 def menu_action() do
    IO.puts IO.ANSI.blue()
    IO.puts "Escolha uma ação: "
    print_action(get_actions())

    v = IO.gets("Digite o número da ação: \n")
    {action,_} = Integer.parse(v)

    if (Enum.find(get_actions(), fn {id, _, _} -> id == action end) == nil) do
      IO.puts IO.ANSI.red() <> "Ação inválida, tente novamente"
      menu_action()
    else
      IO.puts "aqui"
      Enum.find(get_actions(), fn {id, _, _} -> id == action end)
    end
 end


 def get_difficults() do
   [
    {1, "Fácil", 0.15, IO.ANSI.green()},
    {2, "Médio", 0.25, IO.ANSI.yellow()},
    {3, "Difícil", 0.5, IO.ANSI.red()},
    {4, "Impossivel", 0.9, IO.ANSI.red()}
  ]
 end

  def print_difficult([]), do: IO.puts ""
  def print_difficult([{id, action, _, color}|t]) do
    IO.puts color <> "#{id} - #{action}"
    print_difficult(t)
  end

 def menu_difficult() do
    IO.puts IO.ANSI.blue()
    IO.puts "Escolha uma dificuldade: "
    print_difficult(get_difficults())

    v = IO.gets(IO.ANSI.reset() <> "Digite o número da dificuldade " <> IO.ANSI.blue() <> IO.ANSI.italic() <> "(ou digite a porcentagem de minas) \n" <> IO.ANSI.reset())
    {action,_} = Integer.parse(v)

    if (Enum.find(get_difficults(), fn {id, _, _, _} -> id == action end) == nil) do
      {value, _} = Float.parse(v)
      {nil, nil, min(0.99, value), nil}
    else
      Enum.find(get_difficults(), fn {id, _, _, _} -> id == action end)
    end
 end


 def get_user_coords(tabuleiro) do
  IO.puts IO.ANSI.magenta()
  v = IO.gets("Digite uma linha: \n")
  {linha,_} = Integer.parse(v)
  v = IO.gets("Digite uma coluna: \n")
  {coluna,_} = Integer.parse(v)

  if (Minesweeper.is_valid_pos(Minesweeper.get_tam(tabuleiro),linha,coluna)) do
    {linha, coluna}
  else
    IO.puts IO.ANSI.red() <> "Posição inválida, tente novamente"
    get_user_coords(tabuleiro)
  end
 end

 def game_loop(minas,tabuleiro) do
   IO.puts Minesweeper.board_to_string(tabuleiro)

   op = Motor.menu_action()
   { _, _, optionFn } = op

   optionFn.(minas,tabuleiro)
 end


 def gen_mines_board(size) do
   add_mines(ceil(size*size*0.15), size, Minesweeper.gera_mapa_de_minas(size))
 end

 def gen_mines_board(size,d) do
   add_mines(floor(size*size*d), size, Minesweeper.gera_mapa_de_minas(size))
 end
 def add_mines(0,_size,mines), do: mines
 def add_mines(n,size,mines) do

   linha = :rand.uniform(size) - 1
   coluna = :rand.uniform(size) - 1
   if Minesweeper.is_mine(mines,linha,coluna) do
     add_mines(n,size,mines)
   else
     add_mines(n-1,size,Minesweeper.update_pos(mines,linha,coluna,true))
   end
 end
end

Motor.main()
