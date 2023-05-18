@tool
extends EditorPlugin

signal setting_changed(key, value)

const default_material := preload("better_debug_colshape_mat.tres")
const settings_category := "better_col_shape"
var default_settings := {
	"shape_color": {
		"value": default_material.get_shader_parameter("color"),
		"type": TYPE_COLOR,
		"hint": null,
		"hint_string": "The color and alpha of the debug collision shapes"
	}
}
var current_settings := {}
var gizmo_plugin = preload("col3d_gizmo_plugin.gd").new()

func initialise_settings():
	for key in default_settings.keys():
		var setting = default_settings[key]
		var proj_setting_key = "%s/%s" % [settings_category, key]
		
		if not ProjectSettings.has_setting(proj_setting_key):
			ProjectSettings.set(proj_setting_key, setting.value)
			ProjectSettings.add_property_info({
				"name": proj_setting_key,
				"type": setting.type,
				"hint": setting.hint,
				"hint_string": setting.hint_string
			})
		
		current_settings[key] = ProjectSettings.get_setting(proj_setting_key)
		emit_signal("setting_changed", key, current_settings[key])

func check_updated_project_settings():
	for key in current_settings.keys():
		var setting = current_settings[key]
		var proj_setting_key = "%s/%s" % [settings_category, key]
		
		if ProjectSettings.has_setting(proj_setting_key):
			var value = ProjectSettings.get_setting(proj_setting_key)
			
			if value != setting:
				print("BetterCol3DGizmo: setting %s updated to %s" % [key, value])
				current_settings[key] = value
				emit_signal("setting_changed", key, value)

func on_setting_changed(key, value):
	match key:
		"shape_color":
			default_material.set_shader_parameter("color", value)

func _enter_tree():
	setting_changed.connect(on_setting_changed)
	initialise_settings()
	project_settings_changed.connect(check_updated_project_settings)
	add_node_3d_gizmo_plugin(gizmo_plugin)

func _exit_tree():
	remove_node_3d_gizmo_plugin(gizmo_plugin)
	project_settings_changed.disconnect(check_updated_project_settings)
	setting_changed.disconnect(on_setting_changed)

