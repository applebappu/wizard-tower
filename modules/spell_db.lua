local spell_db = {}

spell_db.spell = tools.CopyTable(Entity)
spell_db.spell.char = "*"

spell_db.spell.Cast = function(self)
	table.insert(resources.spawn_table, self)
end

return spell_db
