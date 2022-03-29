require_relative '../lib/jogo.rb'
require_relative '../lib/tabuleiro.rb'
require_relative '../lib/jogador.rb'
require 'pry-byebug'

describe Jogo do

    describe '#initialize' do
    end

    describe '#criar_jogadores' do
        subject(:novo_jogo) { described_class.new() }
        context 'Jogadores 1 escolhe cor 1' do
            before do
                # binding.pry
                allow(novo_jogo).to receive(:gets).and_return('Gustavo','1','Teste')
                allow(novo_jogo).to receive(:puts).exactly(3).times
            end
            it 'cria jogador 1 com cor 1 e jogador 2 com cor 2' do
                expect(Jogador).to receive(:new).with('Gustavo',1)
                expect(Jogador).to receive(:new).with('Teste',2)
                novo_jogo.criar_jogadores
            end
        end

        context 'Jogador 1 inputa cor inicialmente inexistente e depois escolhe 2' do
            before do
                # binding.pry
                allow(novo_jogo).to receive(:gets).and_return('Gustavo','3','2','Teste')
                allow(novo_jogo).to receive(:puts).exactly(4).times
            end
            it 'cria jogador 1 com cor 2 e jogador 2 com cor 1' do
                expect(Jogador).to receive(:new).with('Gustavo',2)
                expect(Jogador).to receive(:new).with('Teste',1)
                novo_jogo.criar_jogadores
            end
        end
    end

    describe '#checar_input' do
        subject(:novo_jogo) { described_class.new() }
        context 'jogador seleciona numero valido' do
            it 'retorna numero' do
                cor =  novo_jogo.checar_input(1)
                expect(cor).to eq(1)
            end
        end

        context 'jogador seleciona numero invalido' do
            it 'retorna nil' do
                cor =  novo_jogo.checar_input(3)
                expect(cor).to eq(nil)
            end
        end
    end

    describe '#sortear_jogador' do
        subject(:novo_jogo) { described_class.new() }
        let(:jogador1) { instance_double(Jogador, nome: 'Gustavo', cor: 1)}
        let(:jogador2) { instance_double(Jogador, nome: 'Teste', cor: 2)}
        context 'realiza o sorteio do jogador que irá iniciar primeiro' do
            before do
                novo_jogo.instance_variable_set(:@jogador1,jogador1)
                novo_jogo.instance_variable_set(:@jogador2,jogador2)
                allow(novo_jogo).to receive(:public_send).and_return(jogador1)
            end

            it 'jogador 1 é sorteado' do
                expect { novo_jogo.sortear_jogador }.to change { novo_jogo.instance_variable_get(:@jogador_atual) }.from(nil).to(jogador1)
            end
        end
    end

    describe '#jogada' do
        subject(:novo_jogo) { described_class.new() }
        let(:jogador1) { instance_double(Jogador, nome: 'Gustavo', cor: 1)}
        let(:jogador2) { instance_double(Jogador, nome: 'Teste', cor: 2)}
        context 'Jogada do jogador1 e escolhe coluna 2 que está vazia' do
            before do 
                novo_jogo.instance_variable_set(:@jogador_atual,jogador1)
                novo_jogo.instance_variable_set(:@jogador1,jogador1)
                novo_jogo.instance_variable_set(:@jogador2,jogador2)
                allow(novo_jogo).to receive(:gets).and_return('2')
            end
            it 'inclui marcador na coluna 2 e atualiza o proximo jogador como sendo jogador 2' do
                expect { novo_jogo.jogada }.to change { novo_jogo.instance_variable_get(:@jogador_atual) }.from(jogador1).to(jogador2)
            end
        end

        context 'Jogada do jogador2 e escolhe coluna 8, inexistente, e depois a coluna 2, que está vazia' do
            before do 
                novo_jogo.instance_variable_set(:@jogador_atual,jogador2)
                novo_jogo.instance_variable_set(:@jogador1,jogador1)
                novo_jogo.instance_variable_set(:@jogador2,jogador2)
                allow(novo_jogo).to receive(:gets).and_return('8','1')
            end
            it 'incluir marcador na coluna 1 e muda jogador atual para jogador 1' do
                expect { novo_jogo.jogada }.to change { novo_jogo.instance_variable_get(:@jogador_atual) }.from(jogador2).to(jogador1)
             end
        end
    end

    describe '#checar_colunas'
        subject(:novo_jogo) { described_class.new() }
        context 'Jogo acabou de iniciar com todas colunas nil' do
            it 'resultado deve ser false' do
                resultado = novo_jogo.checar_colunas
                expect(resultado).to eq(false)
            end
        end
        
        context 'Coluna 3 com 4 resultados consecutivos' do
            before do
                novo_jogo.tabuleiro.coluna3 = [2,1,1,1,1,2]
                novo_jogo.tabuleiro.tabuleiro[2] = [2,1,1,1,1,2]
            end
            it 'resultado deve ser true' do
                resultado = novo_jogo.checar_colunas
                expect(resultado).to eq(true)
            end
        end
                
        context 'Coluna 2 sem 4 resultados consecutivos' do
            before do
                novo_jogo.tabuleiro.coluna2 = [2,1,2,1,1,2]
                novo_jogo.tabuleiro.tabuleiro[1] = [2,1,2,1,1,2]
            end
            it 'resultado deve ser false' do
                resultado = novo_jogo.checar_colunas
                expect(resultado).to eq(false)
            end
        end

        describe '#checar_linhas'
        subject(:novo_jogo) { described_class.new() }
        context 'Jogo acabou de iniciar com todas colunas nil' do
            it 'resultado deve ser false' do
                resultado = novo_jogo.checar_linhas
                expect(resultado).to eq(false)
            end
        end
        
        context 'Linha 1 com 4 resultados consecutivos' do
            before do
                novo_jogo.tabuleiro.coluna1 = [2,nil,nil,nil,nil,nil]
                novo_jogo.tabuleiro.coluna2 = [2,nil,nil,nil,nil,nil]
                novo_jogo.tabuleiro.coluna3 = [2,nil,nil,nil,nil,nil]
                novo_jogo.tabuleiro.coluna4 = [2,nil,nil,nil,nil,nil]
                novo_jogo.tabuleiro.tabuleiro[0] = [2,nil,nil,nil,nil,nil]
                novo_jogo.tabuleiro.tabuleiro[1] = [2,nil,nil,nil,nil,nil]
                novo_jogo.tabuleiro.tabuleiro[2] = [2,nil,nil,nil,nil,nil]
                novo_jogo.tabuleiro.tabuleiro[3] = [2,nil,nil,nil,nil,nil]
            end
            it 'resultado deve ser true' do
                resultado = novo_jogo.checar_linhas
                expect(resultado).to eq(true)
            end
        end
                
        context 'Linha 3 com 4 resultados consecutivos' do
            before do
                novo_jogo.tabuleiro.coluna1 = [nil,nil,2,nil,nil,nil]
                novo_jogo.tabuleiro.coluna2 = [nil,nil,2,nil,nil,nil]
                novo_jogo.tabuleiro.coluna3 = [nil,nil,2,nil,nil,nil]
                novo_jogo.tabuleiro.coluna4 = [nil,nil,2,nil,nil,nil]
                novo_jogo.tabuleiro.tabuleiro[0] = [nil,nil,2,nil,nil,nil]
                novo_jogo.tabuleiro.tabuleiro[1] = [nil,nil,2,nil,nil,nil]
                novo_jogo.tabuleiro.tabuleiro[2] = [nil,nil,2,nil,nil,nil]
                novo_jogo.tabuleiro.tabuleiro[3] = [nil,nil,2,nil,nil,nil]
            end
            it 'resultado deve ser false' do
                resultado = novo_jogo.checar_linhas
                expect(resultado).to eq(true)
            end
        end

        context 'Sem resultados consecutivos' do
            before do
                novo_jogo.tabuleiro.coluna1 = [1,2,2,2,1,nil]
                novo_jogo.tabuleiro.coluna2 = [2,1,1,1,2,nil]
                novo_jogo.tabuleiro.coluna3 = [2,1,2,1,2,nil]
                novo_jogo.tabuleiro.coluna4 = [2,2,2,1,2,nil]
                novo_jogo.tabuleiro.tabuleiro[0] = [1,2,2,2,1,nil]
                novo_jogo.tabuleiro.tabuleiro[1] = [2,1,1,1,2,nil]
                novo_jogo.tabuleiro.tabuleiro[2] = [2,1,2,1,2,nil]
                novo_jogo.tabuleiro.tabuleiro[3] = [2,2,2,1,2,nil]
            end
            it 'resultado deve ser false' do
                resultado = novo_jogo.checar_linhas
                expect(resultado).to eq(false)
            end
        end

        describe '#checar_diagonal_1'
        subject(:novo_jogo) { described_class.new() }
        context 'Jogo acabou de iniciar com todas colunas nil' do
            it 'resultado deve ser false' do
                resultado = novo_jogo.checar_diagonal_1
                expect(resultado).to eq(false)
            end
        end

        context 'Diagonal consecutivos do jogador 1' do
            before do
                novo_jogo.tabuleiro.coluna1 = [1,nil,nil,nil,nil,nil]
                novo_jogo.tabuleiro.coluna2 = [nil,1,nil,nil,nil,nil]
                novo_jogo.tabuleiro.coluna3 = [nil,nil,1,nil,nil,nil]
                novo_jogo.tabuleiro.coluna4 = [nil,nil,nil,1,nil,nil]
                novo_jogo.tabuleiro.tabuleiro[0] = [1,nil,nil,nil,nil,nil]
                novo_jogo.tabuleiro.tabuleiro[1] = [nil,1,nil,nil,nil,nil]
                novo_jogo.tabuleiro.tabuleiro[2] = [nil,nil,1,nil,nil,nil]
                novo_jogo.tabuleiro.tabuleiro[3] = [nil,nil,nil,1,nil,nil]
            end
            it 'resultado deve ser true' do
                resultado = novo_jogo.checar_diagonal_1
                expect(resultado).to eq(true)
            end
        end


        describe '#checar_diagonal_2'
        subject(:novo_jogo) { described_class.new() }
        context 'Jogo acabou de iniciar com todas colunas nil' do
            it 'resultado deve ser false' do
                resultado = novo_jogo.checar_diagonal_2
                expect(resultado).to eq(false)
            end
        end

        context 'Diagonal consecutivos do jogador 1' do
            before do
                novo_jogo.tabuleiro.coluna1 = [nil,nil,nil,nil,nil,1]
                novo_jogo.tabuleiro.coluna2 = [nil,nil,nil,nil,1,nil]
                novo_jogo.tabuleiro.coluna3 = [nil,nil,nil,1,nil,nil]
                novo_jogo.tabuleiro.coluna4 = [nil,nil,1,nil,nil,nil]
                novo_jogo.tabuleiro.tabuleiro[0] = [nil,nil,nil,nil,nil,1]
                novo_jogo.tabuleiro.tabuleiro[1] = [nil,nil,nil,nil,1,nil]
                novo_jogo.tabuleiro.tabuleiro[2] = [nil,nil,nil,1,nil,nil]
                novo_jogo.tabuleiro.tabuleiro[3] = [nil,nil,1,nil,nil,nil]
            end
            it 'resultado deve ser true' do
                resultado = novo_jogo.checar_diagonal_2
                expect(resultado).to eq(true)
            end
        end


        describe '#fim_partida?'
        subject(:novo_jogo) { described_class.new() }
        let(:jogador1) { instance_double(Jogador, nome: 'Gustavo', cor: 1)}
        context 'Jogo sem ganhadores ate o momento' do
            it 'resultado deve ser false' do
                resultado = novo_jogo.fim_partida?
                expect(resultado).to eq(nil)
            end
        end

        context 'Jogo possui combinação de linha com ganhador' do
            before do
                novo_jogo.tabuleiro.coluna1 = [2,nil,nil,nil,nil,nil]
                novo_jogo.tabuleiro.coluna2 = [2,nil,nil,nil,nil,nil]
                novo_jogo.tabuleiro.coluna3 = [2,nil,nil,nil,nil,nil]
                novo_jogo.tabuleiro.coluna4 = [2,nil,nil,nil,nil,nil]
                novo_jogo.tabuleiro.tabuleiro[0] = [2,nil,nil,nil,nil,nil]
                novo_jogo.tabuleiro.tabuleiro[1] = [2,nil,nil,nil,nil,nil]
                novo_jogo.tabuleiro.tabuleiro[2] = [2,nil,nil,nil,nil,nil]
                novo_jogo.tabuleiro.tabuleiro[3] = [2,nil,nil,nil,nil,nil]
                allow(novo_jogo).to receive(:puts).once
                novo_jogo.instance_variable_set(:@jogador1,jogador1)
                novo_jogo.instance_variable_set(:@vencedor,jogador1)
            end
            it 'resultado deve ser true' do
                resultado = novo_jogo.fim_partida?
                expect(resultado).to eq(true)
            end
        end
end
