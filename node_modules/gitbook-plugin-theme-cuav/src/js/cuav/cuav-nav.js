/*
 * Copyright 2017 CUAV.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * 新增 cuav-nav.js
 */

/**
 * 构建动态导航菜单
 * @param  {jQuery} $ jQuery
 */
(function($){

  var gitbook = window.gitbook;

  /**
   * 初始化
   * @function
   */
  var init = function() {

    // TODO 是否需要清空导航栏

    var navbar = gitbook.state.config.pluginsConfig["theme-cuav"].navbar;

    if (!navbar) {
      return;
    }

    var url = navbar.navAjaxUrl;

    if (!url) {
      return;
    }
    
    $.ajax(url, {
      type: 'get',
      dataType: 'json',
      cache: false,
      success: function(data) {

        if (!data) {
          return;
        }
        
        var $navNode = $('#cuav-nav');

        for (var i = 0; i < data.length; ++i) { // 循环构建导航菜单
          var item = data[i];
          if (!item.name) { // 不添加没有菜单名的菜单
            continue;
          }

          var links = item.links;
          if (links) { // 拥有二级菜单

            var $itemNode = $('<li>').addClass('nav-item dropdown');
            var $dropdownNode = $('<a>').addClass('nav-link dropdown-toggle')
              .attr('id', 'navbarDropdownMenuLinkJs' + i)
              .attr('data-toggle', 'dropdown')
              .attr('aria-haspopup', true)
              .attr('aria-expanded', false)
              .attr('href', 'javascript:;')
              .append(item.name);

            var $dropdownMenuNode
              = $("<div>")
                .addClass('dropdown-menu text-center text-lg-left')
                .attr('aria-labelledby', 'navbarDropdownMenuLinkJs' + i);

            $itemNode.append($dropdownNode).append($dropdownMenuNode);

            for (var j = 0; j < links.length; ++j) { // 循环构建二级菜单
              var link = links[j];

              if (link.name) { // 不添加没有菜单名的菜单
                var url = link.url ? link.url : 'javascript:;';
                var $dropdownItemNode
                  = $("<a>")
                    .addClass('dropdown-item')
                    .attr('href', url)
                    $dropdownItemNode.append(link.name);
                $dropdownMenuNode.append($dropdownItemNode);
              }
            }

            $navNode.append($itemNode);
          } else { // 只有一级菜单

            var $itemNode = $("<li>").addClass('nav-item');
            var $linkNode = $("<a>").addClass('nav-link');

            var url = item.url ? item.url : 'javascript:;';
            $linkNode.attr('href', url)
              .append(item.name);

            $itemNode.append($linkNode);
            $navNode.append($itemNode);
          }
        }
      }
    });
  };

  gitbook.push(function() {
    init();
  });

})(jQuery);