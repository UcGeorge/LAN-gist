//
//  Generated file. Do not edit.
//

#include "generated_plugin_registrant.h"

#include <desktop_window/desktop_window_plugin.h>
#include <dropfiles_window/dropfiles_window_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  DesktopWindowPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DesktopWindowPlugin"));
  DropfilesWindowPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DropfilesWindowPlugin"));
}
