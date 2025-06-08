;; Collaboration Platform Contract
;; Facilitates creator collaborations and joint projects

(define-map collaboration-projects
  { project-id: uint }
  {
    title: (string-ascii 100),
    description: (string-ascii 500),
    lead-creator: principal,
    created-at: uint,
    status: (string-ascii 20),
    total-revenue: uint
  }
)

(define-map project-collaborators
  { project-id: uint, collaborator: principal }
  {
    joined-at: uint,
    role: (string-ascii 50),
    revenue-share: uint
  }
)

(define-map collaboration-invites
  { project-id: uint, invitee: principal }
  {
    invited-by: principal,
    invited-at: uint,
    status: (string-ascii 20)
  }
)

(define-data-var next-project-id uint u1)

;; Create collaboration project
(define-public (create-project
  (title (string-ascii 100))
  (description (string-ascii 500))
)
  (let
    (
      (project-id (var-get next-project-id))
      (creator tx-sender)
    )
    (map-set collaboration-projects
      { project-id: project-id }
      {
        title: title,
        description: description,
        lead-creator: creator,
        created-at: block-height,
        status: "active",
        total-revenue: u0
      }
    )
    ;; Add creator as first collaborator
    (map-set project-collaborators
      { project-id: project-id, collaborator: creator }
      {
        joined-at: block-height,
        role: "lead",
        revenue-share: u5000 ;; 50% for lead
      }
    )
    (var-set next-project-id (+ project-id u1))
    (ok project-id)
  )
)

;; Invite collaborator
(define-public (invite-collaborator (project-id uint) (invitee principal))
  (let
    (
      (project-info (unwrap! (map-get? collaboration-projects { project-id: project-id }) (err u500)))
      (inviter tx-sender)
    )
    (asserts! (is-eq inviter (get lead-creator project-info)) (err u501))
    (asserts! (is-none (map-get? collaboration-invites { project-id: project-id, invitee: invitee })) (err u502))
    (map-set collaboration-invites
      { project-id: project-id, invitee: invitee }
      {
        invited-by: inviter,
        invited-at: block-height,
        status: "pending"
      }
    )
    (ok true)
  )
)

;; Accept collaboration invite
(define-public (accept-invite (project-id uint) (role (string-ascii 50)) (revenue-share uint))
  (let
    (
      (invitee tx-sender)
      (invite-info (unwrap! (map-get? collaboration-invites { project-id: project-id, invitee: invitee }) (err u503)))
    )
    (asserts! (is-eq (get status invite-info) "pending") (err u504))
    (map-set project-collaborators
      { project-id: project-id, collaborator: invitee }
      {
        joined-at: block-height,
        role: role,
        revenue-share: revenue-share
      }
    )
    (map-set collaboration-invites
      { project-id: project-id, invitee: invitee }
      (merge invite-info { status: "accepted" })
    )
    (ok true)
  )
)

;; Distribute project revenue
(define-public (distribute-project-revenue (project-id uint) (total-amount uint))
  (let
    (
      (project-info (unwrap! (map-get? collaboration-projects { project-id: project-id }) (err u505)))
      (distributor tx-sender)
    )
    (asserts! (is-eq distributor (get lead-creator project-info)) (err u506))
    (map-set collaboration-projects
      { project-id: project-id }
      (merge project-info { total-revenue: (+ (get total-revenue project-info) total-amount) })
    )
    (ok true)
  )
)

;; Get project info
(define-read-only (get-project-info (project-id uint))
  (map-get? collaboration-projects { project-id: project-id })
)

;; Get collaborator info
(define-read-only (get-collaborator-info (project-id uint) (collaborator principal))
  (map-get? project-collaborators { project-id: project-id, collaborator: collaborator })
)

;; Check invite status
(define-read-only (get-invite-status (project-id uint) (invitee principal))
  (map-get? collaboration-invites { project-id: project-id, invitee: invitee })
)
