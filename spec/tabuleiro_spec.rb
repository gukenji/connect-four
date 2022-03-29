require_relative '../lib/tabuleiro.rb'
require_relative '../lib/jogador.rb'
require 'pry-byebug'

describe Tabuleiro do
    describe '#initialize' do
    #Initialize -> sem necessidade de teste (apenas cria array)
    end

    describe '#checa_espaco_coluna' do
        subject(:novo_tabuleiro) { described_class.new() }
        context 'jogador escolha coluna 1 com espaço' do
            it 'e é retornado true' do
                coluna = novo_tabuleiro.instance_variable_get(:@coluna1)
                check = novo_tabuleiro.checa_espaco_coluna(1)
                expect(check).to eq(true)
            end
        end

        context 'jogador escolha coluna 1 sem espaço' do
            before do
                novo_tabuleiro.coluna1 = [1,1,1,1,1,1]
            end
            it 'e é retornado mensagem de erro' do
                expect(novo_tabuleiro).to receive(:puts).with("Coluna cheia! Escolha outra coluna.").once
                novo_tabuleiro.checa_espaco_coluna(1)

            end
        end


        context 'jogador escolha coluna 8 inexistente' do
            it 'e é retornado mensagem de erro' do
                expect(novo_tabuleiro).to receive(:puts).with('Escolha uma coluna de 1 até 7!').once
                novo_tabuleiro.checa_espaco_coluna(8)
            end
        end
    end


    describe '#retorna_proximo_espaco' do
        subject(:novo_tabuleiro) { described_class.new() }
        context 'jogador seleciona coluna 1 vazia' do
            it 'e é retornado o index 0' do
                index = novo_tabuleiro.retorna_proximo_espaco(1)
                expect(index).to eq(0)
            end
        end

        context 'jogador seleciona coluna 1 com  3 jogadas anteriores' do
            before do
                novo_tabuleiro.coluna1 = [1,1,1,nil,nil,nil]
            end
            it 'e é retornado o indice 3' do
                index = novo_tabuleiro.retorna_proximo_espaco(1)
                expect(index).to eq(3)
            end
        end

        context 'jogador seleciona coluna 1 sem espaço vazio' do
            before do
                novo_tabuleiro.coluna1 = [1,1,1,1,1,1]
            end
            it 'e é retornado nil' do
                index = novo_tabuleiro.retorna_proximo_espaco(1)
                expect(index).to eq(nil)
            end
        end
    end


    describe '#atualizar_tabuleiro' do
        subject(:novo_tabuleiro) { described_class.new() }
        let(:jogador) { instance_double(Jogador, nome: 'Gustavo', cor: 1) }

        context 'jogador seleciona coluna 1 vazia' do
            it 'coluna é preenchida com dado do jogador' do
                coluna = novo_tabuleiro.instance_variable_get(:@coluna1)
                novo_tabuleiro.atualizar_tabuleiro(1,jogador.cor)
                expect(coluna).to eq([1,nil,nil,nil,nil,nil])
            end
        end

        context 'jogador seleciona coluna 1 com 1 jogada anterior' do
            before do
                novo_tabuleiro.coluna1 = [1,nil,nil,nil,nil,nil]
            end
            it 'coluna é preenchida com dado do jogador' do
                coluna = novo_tabuleiro.instance_variable_get(:@coluna1)
                novo_tabuleiro.atualizar_tabuleiro(1,jogador.cor)
                expect(coluna).to eq([1,1,nil,nil,nil,nil])
            end
        end
    end

end
