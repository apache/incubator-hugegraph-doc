/*
 * Modified By 黄伟枞<weicong@cuav.net>
 * Modify:
 * 将 theme-defult 修改为 theme-cuav
 * 
 */
module.exports = {
    hooks: {
        config: function(config) {
            config.styles = config.styles || config.pluginsConfig['theme-cuav'].styles;

            return config;
        }
    }
};


