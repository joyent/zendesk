view: tickets {
  sql_table_name: stitch_zendesk.tickets ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

#   dimension: assignee_email {
#     description: "the requester is the customer who initiated the ticket. the email is retrieved from the `users` table."
#     sql: ${assignees.email} ;;
#   }

  ## include only if your Zendesk application utilizes the assignee_id field
  dimension: assignee_id {
    type: number
    value_format_name: id
    sql: ${TABLE}.assignee_id ;;
  }

  dimension_group: created_at {
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.created_at::timestamp ;;
  }

  dimension: group_id {
    type: number
    value_format_name: id
    sql: ${TABLE}.group_id ;;
  }

  dimension: organization_id {
    type: number
    value_format_name: id
    sql: ${TABLE}.organization_id ;;
  }

  # dimension: organization_name {
  #   type: string
  #   sql: ${organizations.name} ;;
  # }

  dimension: recipient {
    type: string
    sql: ${TABLE}.recipient ;;
  }

  # dimension: requester_email {
  #   description: "the requester is the customer who initiated the ticket. the email is retrieved from the `users` table."
  #   sql: ${requesters.email} ;;
  # }

  dimension: requester_id {
    description: "the requester is the customer who initiated the ticket"
    type: number
    value_format_name: id
    sql: ${TABLE}.requester_id ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  ## depending on use, either this field or "via_channel" will represent the channel the ticket came through
  dimension: subject {
    type: string
    sql: ${TABLE}.subject ;;
  }

  ## The submitter is always the first to comment on a ticket
  dimension: submitter_id {
    description: "a submitter is either a customer or an agent submitting on behalf of a customer"
    type: number
    value_format_name: id
    sql: ${TABLE}.submitter_id ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension: via__channel {
    type: string
    sql: ${TABLE}.via__channel ;;
  }

  measure: count {
    type: count
  }

  # ----- ADDITIONAL FIELDS -----

  dimension: is_backlogged {
    type: yesno
    sql: ${status} = 'pending' ;;
  }

  dimension: is_new {
    type: yesno
    sql: ${status} = 'new' ;;
  }

  dimension: is_open {
    type: yesno
    sql: ${status} = 'open' ;;
  }

  dimension: is_solved {
    description: "solved tickets have either a solved or closed status"
    type: yesno
    sql: ${status} = 'solved' OR ${status} = 'closed' ;;
  }

  dimension: subject_category {
    sql: CASE
      WHEN ${subject} LIKE 'Chat%' THEN 'Chat'
      WHEN ${subject} LIKE 'Offline message%' THEN 'Offline Message'
      WHEN ${subject} LIKE 'Phone%' THEN 'Phone Call'
      ELSE 'Other'
      END
       ;;
  }

  measure: count_pending_tickets {
    type: count

    filters: {
      field: is_backlogged
      value: "Yes"
    }
  }

  measure: count_new_tickets {
    type: count

    filters: {
      field: is_new
      value: "Yes"
    }
  }

  measure: count_open_tickets {
    type: count

    filters: {
      field: is_open
      value: "Yes"
    }
  }

  measure: count_solved_tickets {
    type: count

    filters: {
      field: is_solved
      value: "Yes"
    }
  }

  measure: count_distinct_organizations {
    type: count_distinct
    sql: ${organization_id} ;;
  }

  # measure: count_orgs_submitting {
  #   type: count_distinct
  #   sql: ${organizations.name} ;;

  #   filters: {
  #     field: organization_name
  #     value: "-NULL"
  #   }
  # }

  ############ TIME FIELDS ###########

  dimension_group: time {
    type: time
    ###   use day_of_week
    timeframes: [day_of_week, hour_of_day]
    sql: ${TABLE}.created_at::timestamp ;;
  }
}


### REVIEW BELOW
# ----- Sets of fields for drilling ------
#   sets:
#     detail:
#     - via__source__from__ticket_id
#     - via__source__from__name
#     - via__source__to__name
#     - organizations.id
#     - organizations.name
#     - audits.count
#     - zendesk_ticket_metrics.count
