@tool
extends PanelContainer

var title : String = 'None': set = settitle
var desc : String = 'None' : set = setdesc

func setdesc(v):
	desc = v
	$VBoxContainer/ScrollContainer/MarginContainer/Descricao.text = v
	
func settitle(v):
	title = v
	$VBoxContainer/MarginContainer/Titulo.text = v
