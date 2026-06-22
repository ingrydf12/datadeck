# Cartas

## Map

Executar a mesma operação em todos os itens de um iterável de entrada.

## Filter

Filtrar elementos de iteráveis que satisfaçam determinadas condições.

`Filter(funcao, iteravel)`

**Exemplo:**
	
```py
def numeros_positivos(numeros):
	numeros_positivos = []

	for num in numeros:
		# Condição de filtragem
		if num > 0:
			numeros_positivos.append(num)

	return numeros_positivos

print(numeros_positivos([-2, -1, 0, 1, 2]))

```

## Insert

Inserir um elemento em determinada posição;

**X**

## Push 
- Insere um elemento no final da lista
