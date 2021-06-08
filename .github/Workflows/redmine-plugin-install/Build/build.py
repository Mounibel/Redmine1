Plugins
Plugin list
A full list of available Redmine plugins can be found at the Plugin Directory.

More plugins (some in very early development), which are not listed at the Plugin Directory but are publicly available on GitHub can be found using a search like this.

Installing a plugin
1. Copy your plugin directory into #{RAILS_ROOT}/plugins. If you are downloading the plugin directly from GitHub, you can do so by changing into your plugin directory and issuing a command like git clone git://github.com/user_name/name_of_the_plugin.git.

2. If the plugin requires a migration, run the following command in #{RAILS_ROOT} to upgrade your database (make a db backup before).

bundle exec rake redmine:plugins:migrate RAILS_ENV=production
3. Restart Redmine

You should now be able to see the plugin list in Administration -> Plugins and configure the newly installed plugin (if the plugin requires to be configured).

Uninstalling a plugin
1. If the plugin required a migration, run the following command to downgrade your database (make a db backup before):

bundle exec rake redmine:plugins:migrate NAME=plugin_name VERSION=0 RAILS_ENV=production
2. Remove your plugin from the plugins folder: #{RAILS_ROOT}/plugins.

3. Restart Redmine

Writing plugins
There is a step-by-step tutorial about writing a plugin. Some more (detailed) information is collected and stored in the "plugin internals" page.
More (general) developer information can be found in the Redmine Developer Guide.

Migrating Plugins
There are changes in Plugins API or new Rails requirements which need to be considered if you want to use plugin from prior version of redmine.
In any case it's proposed to update and migrate redmine core system first without plugins and then if stable try to drop in one by one, to know where problems come from if any.

Consideration towards plugins which overwrite views completely because of bad coding style or there is no "hook" available shall be made in any case. Maybe you can collect and write down plugin references here which are of this type.

Let's start with..

Redmine_blocks
Redmine 1.3 > 1.4
routes.rb which defines url to controller (parameter, action) mapping must be created in <plugin>/config/routes.rb
ARCondition is gone with no replacement
TabularFormBuilder is now Redmine::Views::LabelledFormBuilder
defining your own context menus now requires helper :context_menus in the respective controller
of course, returning is deprecated in favor of tap
if you're doing anything with repos check it twice, because there can be multiple repos now per project
Project#visible_by is deprecated and replaced by Project#visible_condition
Redmine 1.4 > 2.x
Writing plugins compatible with both Redmine 1.x and 2.x - some tips
Writing Redmine 2.x plugins
Tutorial
