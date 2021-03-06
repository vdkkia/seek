module Seek
  module ProjectHierarchies
    module AdminDefinedRolesExtension
      def add_roles(roles)
        Array(roles).each do |role|
          mask = Seek::Roles::Roles.instance.mask_for_role(role.role_name)
          project_ids_before_add = admin_defined_role_projects.where(role_mask: mask).map(&:project_id)
          # add roles to person's direct projects
          super(role)
          roles_added = admin_defined_role_projects.where(role_mask: mask).select { |role| !project_ids_before_add.include?(role.project_id) }
          # add roles to sub-projects
          roles_added.each do |role|
            role.project.descendants.each do |sub_proj|
              admin_defined_role_projects << admin_defined_role_projects.where(project_id: sub_proj.id, role_mask: role.role_mask).first_or_initialize
            end
          end
        end
      end

      def remove_roles(roles)
        Array(roles).each do |role|
          mask = Seek::Roles::Roles.instance.mask_for_role(role.role_name)
          roles_before_remove = admin_defined_role_projects.where(role_mask: mask).map { |role| [role.project_id, role.role_mask] }
          super(roles)
          roles_removed = roles_before_remove.select { |role| admin_defined_role_projects.where(project_id: role[0], role_mask: role[1]).empty? }
          # remove roles to sub-projects
          roles_removed.each do |role|
            Project.where(id: role[0]).first.descendants.each do |sub_proj|
              admin_defined_role_projects.where(project_id: sub_proj.id, role_mask: role[1]).first.destroy
            end
          end
        end
      end
    end
  end
end
