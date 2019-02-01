#lang racket

(require "./oauth-single-user.rkt")
    
#|
~~~~~~~~~~~   
twitter-racket api
~~~~~~~~~~~
This library contains functionality for access to core Twitter API calls,
Twitter Authentication, and miscellaneous methods that are useful when
dealing with the Twitter API
|#

(define sid_api_key "Rr5AJHIUERG7hl9gDE2rDPgth")
(define sid_api_secret "s2D2jRjzETTd4RHilT2lYYR6fVjrJaC3Rz0BGXlNjK4vWYtvxO")
(define sid_api_access_token "788048305578057728-bW8SLhtSkvn4qSF26b6ijZgnA2fBY9h")
(define sid_api_access_token_secret "WbaHJoB4JmAcmrgKRNAJovEZQv0nKBhmkO4uSlmQtjZsI")

#|
Positive test: 
(define sid-acc (new twitter [api_key sid_api_key]
                     [api_secret sid_api_secret]
                     [access_token sid_api_access_token]
                     [access_token_secret sid_api_access_token_secret]))
|#

#|
Negative test:
(define fake-acc (new twitter [api_key "XXXX"]
                     [api_secret "XXXX"]
                     [access_token "XXXX"]
                     [access_token_secret "XXXX"]))


|#


(define twitter
  (class object%
    (super-new)
    (init-field api_key)
    (init-field api_secret)
    (init-field access_token)
    (init-field access_token_secret)


    ;; twitter-oauth will store the http request with oauth1.0 authentication
    ;; headers based on inputted values of api_key, api_secret etc
    (define twitter-oauth
      (new oauth-single-user%  
     [consumer-key api_key]
     [consumer-secret api_secret]
     [access-token access_token]
     [access-token-secret access_token_secret]))
    

    ;; tweet: String -> #f || String
    ;; tweets a message on twitter account authenticated by `twitter-oauth`
    ;; object.
    (define/public (tweet message)
      (let ([result (send twitter-oauth
                         post-request
                         "https://api.twitter.com/1.1/statuses/update.json"
                         (list (cons 'status message)))])
        (if (hash-has-key? result 'errors)
            #f
            "Tweet successful")))

    ;; follow: String -> #f || String
    ;; follows `user-name` on twitter account authenticated by `twitter-oauth`
    ;; object
    (define/public (follow user-name)
      (let ([result (send twitter-oauth
            post-request "https://api.twitter.com/1.1/friendships/create.json"
            (list (cons 'screen_name user-name) (cons 'follow "true")))])
        (if (hash-has-key? result 'errors)
        #f
        (string-append "Successfully followed " user-name))))


    ;; follow: String -> #f || hasheq
    ;; Searches `query` via twitter account authenticated by `twitter-oauth`
    ;; object
    (define/public (search query)
      (let ([result (send twitter-oauth get-request
            "https://api.twitter.com/1.1/search/tweets.json"
            (list (cons 'q query)))])
        (if (hash-has-key? result 'errors)
            #f
            result)))

    ;; show-home-timeline: void -> #f || hasheq
    ;; Pulls home timeline for twitter account authenticated by `twitter-oauth`
    ;; object
    ;; Developer note: limiting the displayed number to 10 for demonstration
    (define/public (show-home-timeline)
      (let ([result (send twitter-oauth get-request
            "https://api.twitter.com/1.1/statuses/home_timeline.json"
            (list (cons 'count "10")))])
        (if (hash-has-key? result 'errors)
            #f
            result)))
    ;; show-user-timeline: void -> #f || hasheq
    ;; Pulls user timeline for twitter account authenticated by `twitter-oauth`
    ;; object
    ;; limiting the displayed number to 10 for demonstration
    (define/public (show-user-timeline)
      (let ([result (send twitter-oauth get-request
            "https://api.twitter.com/1.1/statuses/user_timeline.json"
            (list (cons 'count "10")))])
        (if (hash-has-key? result 'errors)
            #f
            result)))

    ;; show-mentions-timeline: void -> #f || hasheq
    ;; Shows mentions timeline for twitter account authenticated by `twitter-oauth`
    ;; object
    ;; limiting the displayed number to 10 for demonstration
    (define/public (show-mentions-timeline)
      (let ([result (send twitter-oauth get-request
            "https://api.twitter.com/1.1/statuses/mentions_timeline.json"
            (list (cons 'count "10")))])
        (if (hash-has-key? result 'errors)
            #f
            result)))
    ;; show-mentions-timeline: void -> #f || hasheq
    ;; Pulls user-IDs for twitter account authenticated by `twitter-oauth`
    ;; object
    ;; limiting the displayed number to 10 for demonstration            
    (define/public (show-friends)
      (let ([result (send twitter-oauth get-request
            "https://api.twitter.com/1.1/friends/ids.json")])
        (if (hash-has-key? result 'errors)
            #f
            result)))))
      


    
    

    




  




