# encoding: utf-8
#
# Redmine - project management software
# Copyright (C) 2006-2014  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

module WikiHelper

  def wiki_page_options_for_select(pages, selected = nil, parent = nil, level = 0)
    pages = pages.group_by(&:parent) unless pages.is_a?(Hash)
    s = ''.html_safe
    if pages.has_key?(parent)
      pages[parent].each do |page|
        attrs = "value='#{page.id}'"
        attrs << " selected='selected'" if selected == page
        indent = (level > 0) ? ('&nbsp;' * level * 2 + '&#187; ') : ''

        s << content_tag('option', (indent + h(page.pretty_title)).html_safe, :value => page.id.to_s, :selected => selected == page) +
               wiki_page_options_for_select(pages, selected, page, level + 1)
      end
    end
    s
  end

  def wiki_page_breadcrumb(page)
    breadcrumb(page.ancestors.reverse.collect {|parent|
      link_to(h(parent.pretty_title), {:controller => 'wiki', :action => 'show', :id => parent.title, :project_id => parent.project, :version => nil})
    })
  end

  def contributors(project, page)
    contributorsDict = ActiveSupport::OrderedHash.new

    versions = page.content.versions.
      select("id, author_id, version").
      reorder('version DESC').
      all

    versions.each do |ver|
      unless ver.author.id.nil?
        contributorsDict[ver.author.id] = {:name => ver.author.name, :contributorTo => 'wiki contributor'}
      end    
    end

    unless project.repository.nil?
      project.repository.committers.each do |committer, user_id|
        unless user_id.nil?
          if contributorsDict.has_key?(user_id)
            contributorsDict[user_id] = {:name => committer, :contributorTo => 'wiki & code contributor'}
          else
            contributorsDict[user_id] = {:name => committer, :contributorTo => 'code contributor'}
          end
        else  
          contributorsDict[committer.to_s.split('<').first] = {:name => committer, :contributorTo => 'code contributor'}
        end  
      end
    end

    #    project.memberships.each do |user|
    #      contributorsDict[user.user_id] = user.name
    #    end

    return contributorsDict
  end

end
