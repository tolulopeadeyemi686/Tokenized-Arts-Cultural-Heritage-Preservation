;; Audience Engagement Contract
;; Manages likes, comments, and follower relationships

(define-map content-likes
  { content-id: uint, user: principal }
  { liked-at: uint }
)

(define-map content-comments
  { comment-id: uint }
  {
    content-id: uint,
    user: principal,
    comment-text: (string-ascii 500),
    created-at: uint
  }
)

(define-map follower-relationships
  { follower: principal, creator: principal }
  { followed-at: uint }
)

(define-map engagement-stats
  { content-id: uint }
  {
    like-count: uint,
    comment-count: uint,
    engagement-score: uint
  }
)

(define-data-var next-comment-id uint u1)

;; Like content
(define-public (like-content (content-id uint))
  (let ((user tx-sender))
    (asserts! (is-none (map-get? content-likes { content-id: content-id, user: user })) (err u400))
    (map-set content-likes
      { content-id: content-id, user: user }
      { liked-at: block-height }
    )
    ;; Update engagement stats
    (let
      (
        (current-stats (default-to
          { like-count: u0, comment-count: u0, engagement-score: u0 }
          (map-get? engagement-stats { content-id: content-id })
        ))
      )
      (map-set engagement-stats
        { content-id: content-id }
        (merge current-stats { like-count: (+ (get like-count current-stats) u1) })
      )
    )
    (ok true)
  )
)

;; Unlike content
(define-public (unlike-content (content-id uint))
  (let ((user tx-sender))
    (asserts! (is-some (map-get? content-likes { content-id: content-id, user: user })) (err u401))
    (map-delete content-likes { content-id: content-id, user: user })
    ;; Update engagement stats
    (let
      (
        (current-stats (unwrap-panic (map-get? engagement-stats { content-id: content-id })))
      )
      (map-set engagement-stats
        { content-id: content-id }
        (merge current-stats { like-count: (- (get like-count current-stats) u1) })
      )
    )
    (ok true)
  )
)

;; Add comment
(define-public (add-comment (content-id uint) (comment-text (string-ascii 500)))
  (let
    (
      (comment-id (var-get next-comment-id))
      (user tx-sender)
    )
    (map-set content-comments
      { comment-id: comment-id }
      {
        content-id: content-id,
        user: user,
        comment-text: comment-text,
        created-at: block-height
      }
    )
    (var-set next-comment-id (+ comment-id u1))
    ;; Update engagement stats
    (let
      (
        (current-stats (default-to
          { like-count: u0, comment-count: u0, engagement-score: u0 }
          (map-get? engagement-stats { content-id: content-id })
        ))
      )
      (map-set engagement-stats
        { content-id: content-id }
        (merge current-stats { comment-count: (+ (get comment-count current-stats) u1) })
      )
    )
    (ok comment-id)
  )
)

;; Follow creator
(define-public (follow-creator (creator principal))
  (let ((follower tx-sender))
    (asserts! (not (is-eq follower creator)) (err u402))
    (asserts! (is-none (map-get? follower-relationships { follower: follower, creator: creator })) (err u403))
    (map-set follower-relationships
      { follower: follower, creator: creator }
      { followed-at: block-height }
    )
    (ok true)
  )
)

;; Unfollow creator
(define-public (unfollow-creator (creator principal))
  (let ((follower tx-sender))
    (asserts! (is-some (map-get? follower-relationships { follower: follower, creator: creator })) (err u404))
    (map-delete follower-relationships { follower: follower, creator: creator })
    (ok true)
  )
)

;; Get engagement stats
(define-read-only (get-engagement-stats (content-id uint))
  (map-get? engagement-stats { content-id: content-id })
)

;; Check if user liked content
(define-read-only (has-liked (content-id uint) (user principal))
  (is-some (map-get? content-likes { content-id: content-id, user: user }))
)

;; Check if following creator
(define-read-only (is-following (follower principal) (creator principal))
  (is-some (map-get? follower-relationships { follower: follower, creator: creator }))
)
