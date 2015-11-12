"use strict";

/**
 * Routing Rules
 */

angular.module('myApp')
  .config(function($stateProvider, $urlRouterProvider) {
    $urlRouterProvider.otherwise("/");

    //$urlRouterProvider.when('/event', '/event/list/day1');
    //$urlRouterProvider.when('/event/list', '/event/list/day1');
    //
    //$stateProvider
    //  .state('root', {
    //    url: '/',
    //    templateUrl: "partials/root.html"
    //  })
    //;

  })
;